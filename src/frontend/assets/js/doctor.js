(() => {
"use strict";
const API_BASE="https://sprang-hesitancy-unwanted.ngrok-free.dev/webhook";
const STORAGE_KEY="hospital_doctor";
const knownDoctors={1:"د. شادي الحداد",2:"د. عاطف أبو حطب",3:"د. نور قويدر",4:"د. زكريا سلمي",5:"د. أيمن سعد",6:"د. ناصر أبو شعبان",7:"د. مروان أبو سعدة",8:"د. حازم الحداد",9:"د. حسن خلف",10:"د. حسن العطار"};

const els={
loginView:document.getElementById("loginView"),dashboardView:document.getElementById("dashboardView"),
loginAlert:document.getElementById("loginAlert"),doctorIdInput:document.getElementById("doctorIdInput"),
openDoctorBtn:document.getElementById("openDoctorBtn"),logoutDoctorBtn:document.getElementById("logoutDoctorBtn"),
headerDoctorName:document.getElementById("headerDoctorName"),headerDoctorId:document.getElementById("headerDoctorId"),
welcomeDoctorName:document.getElementById("welcomeDoctorName"),pageAlert:document.getElementById("pageAlert"),
refreshQueueBtn:document.getElementById("refreshQueueBtn"),waitingCount:document.getElementById("waitingCount"),
servingNumber:document.getElementById("servingNumber"),totalCount:document.getElementById("totalCount"),
currentCard:document.getElementById("currentCard"),noCurrentCard:document.getElementById("noCurrentCard"),
currentQueueNumber:document.getElementById("currentQueueNumber"),currentPatientName:document.getElementById("currentPatientName"),
currentPatientNationalId:document.getElementById("currentPatientNationalId"),currentBookingId:document.getElementById("currentBookingId"),
completePatientBtn:document.getElementById("completePatientBtn"),callNextBtn:document.getElementById("callNextBtn"),
queueLoading:document.getElementById("queueLoading"),queueEmpty:document.getElementById("queueEmpty"),
queueTableWrap:document.getElementById("queueTableWrap"),queueTableBody:document.getElementById("queueTableBody")
};
let doctorId=null,queueItems=[],refreshTimer=null,requestInProgress=false;

function escapeHtml(v){return String(v??"").replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#039;");}
function normalizeArray(raw){if(Array.isArray(raw))return raw;if(Array.isArray(raw?.data))return raw.data;if(Array.isArray(raw?.queue))return raw.queue;if(Array.isArray(raw?.patients))return raw.patients;if(raw&&typeof raw==="object"&&Object.keys(raw).length)return[raw];return[];}
function firstObject(raw){return normalizeArray(raw)[0]??null;}

async function api(path,options={}){
const response=await fetch(`${API_BASE}/${path}`,{...options,headers:{"Content-Type":"application/json","ngrok-skip-browser-warning":"1",...(options.headers||{})}});
const text=await response.text();let data=null;
try{data=text?JSON.parse(text):null}catch{throw new Error(text||`HTTP ${response.status}`);}
if(!response.ok)throw new Error(data?.message||`HTTP ${response.status}`);
return data;
}
function showPageAlert(message,type="danger"){els.pageAlert.className=`alert alert-${type} mt-4`;els.pageAlert.textContent=message;}
function clearPageAlert(){els.pageAlert.className="alert d-none mt-4";els.pageAlert.textContent="";}
function statusMeta(status){if(status==="Serving")return{text:"قيد الخدمة",className:"status-serving"};if(status==="Waiting")return{text:"بانتظار الدور",className:"status-waiting"};return{text:status||"—",className:"text-bg-light"};}

function renderHeaderName(){const first=queueItems.find(x=>x.doctor_name||x.clinic_name);const name=first?.doctor_name||knownDoctors[doctorId]||"الطبيب";els.headerDoctorName.textContent=name;els.welcomeDoctorName.textContent=name;els.headerDoctorId.textContent=doctorId;}
function renderCurrentPatient(){
const current=queueItems.find(x=>x.status==="Serving");
if(!current){els.currentCard.classList.add("d-none");els.noCurrentCard.classList.remove("d-none");els.servingNumber.textContent="—";els.completePatientBtn.disabled=true;return;}
els.currentCard.classList.remove("d-none");els.noCurrentCard.classList.add("d-none");
els.currentQueueNumber.textContent=current.queue_number??"—";els.currentPatientName.textContent=current.patient_name??"—";
els.currentPatientNationalId.textContent=current.national_id??"—";els.currentBookingId.textContent=current.booking_id??"—";
els.servingNumber.textContent=current.queue_number??"—";els.completePatientBtn.disabled=false;
}
function renderStats(){const waiting=queueItems.filter(x=>x.status==="Waiting").length;const serving=queueItems.find(x=>x.status==="Serving");els.waitingCount.textContent=waiting;els.totalCount.textContent=queueItems.length;els.servingNumber.textContent=serving?.queue_number??"—";}
function renderQueueTable(){
if(!queueItems.length){els.queueTableWrap.classList.add("d-none");els.queueEmpty.classList.remove("d-none");return;}
els.queueEmpty.classList.add("d-none");els.queueTableWrap.classList.remove("d-none");
els.queueTableBody.innerHTML=queueItems.map(item=>{const meta=statusMeta(item.status);return `<tr><td><strong>${escapeHtml(item.queue_number??"—")}</strong></td><td><div class="fw-semibold">${escapeHtml(item.patient_name??"—")}</div>${item.clinic_name?`<div class="small text-secondary">${escapeHtml(item.clinic_name)}</div>`:""}</td><td>${escapeHtml(item.national_id??"—")}</td><td><span class="badge rounded-pill ${meta.className}">${meta.text}</span></td><td dir="ltr">${escapeHtml(item.created_at??"—")}</td></tr>`;}).join("");
}
function renderAll(){renderHeaderName();renderStats();renderCurrentPatient();renderQueueTable();}

async function loadQueue(silent=false){
if(!doctorId||requestInProgress)return;requestInProgress=true;
if(!silent){els.queueLoading.classList.remove("d-none");els.queueTableWrap.classList.add("d-none");els.queueEmpty.classList.add("d-none");}
try{queueItems=normalizeArray(await api(`doctor/queue?doctor_id=${encodeURIComponent(doctorId)}`));renderAll();clearPageAlert();}
catch(error){if(!silent){showPageAlert(error.message||"تعذر تحميل طابور الطبيب.");queueItems=[];renderAll();}}
finally{els.queueLoading.classList.add("d-none");requestInProgress=false;}
}

async function callNextPatient(){
if(!doctorId)return;els.callNextBtn.disabled=true;els.callNextBtn.textContent="جاري الاستدعاء...";
try{
const raw=await api("doctor/call-next",{method:"POST",body:JSON.stringify({doctor_id:Number(doctorId)})});
if(raw?.success===false)throw new Error(raw.message||"تعذر استدعاء المريض.");
await loadQueue(true);
const patient=firstObject(raw);
showPageAlert(patient?.patient_name?`تم استدعاء ${patient.patient_name} بنجاح ✅`:(raw?.message||"تم استدعاء المريض التالي ✅"),"success");
}catch(error){showPageAlert(error.message||"تعذر استدعاء المريض التالي.");}
finally{els.callNextBtn.disabled=false;els.callNextBtn.textContent="استدعاء المريض التالي";}
}

async function completeCurrentPatient(){
const current=queueItems.find(x=>x.status==="Serving");if(!current)return;
els.completePatientBtn.disabled=true;els.completePatientBtn.textContent="جاري الإنهاء...";
try{
const raw=await api("doctor/complete-patient",{method:"POST",body:JSON.stringify({booking_id:Number(current.booking_id),doctor_id:Number(doctorId)})});
if(raw?.success===false)throw new Error(raw.message||"تعذر إنهاء خدمة المريض.");
await loadQueue(true);showPageAlert(raw?.message||"تم إنهاء خدمة المريض بنجاح ✅","success");
}catch(error){showPageAlert(error.message||"تعذر إنهاء خدمة المريض.");}
finally{els.completePatientBtn.disabled=false;els.completePatientBtn.textContent="إنهاء المريض";}
}

function startDashboard(id){
doctorId=Number(id);
if(!Number.isInteger(doctorId)||doctorId<1){els.loginAlert.textContent="أدخلي معرّف طبيب صحيح.";els.loginAlert.classList.remove("d-none");return;}
els.loginAlert.classList.add("d-none");
sessionStorage.setItem(STORAGE_KEY,JSON.stringify({doctor_id:doctorId,doctor_name:knownDoctors[doctorId]||"الطبيب"}));
els.loginView.classList.add("d-none");els.dashboardView.classList.remove("d-none");loadQueue(false);
if(refreshTimer)clearInterval(refreshTimer);refreshTimer=setInterval(()=>loadQueue(true),5000);
}
function logoutDoctor(){if(refreshTimer){clearInterval(refreshTimer);refreshTimer=null;}sessionStorage.removeItem(STORAGE_KEY);doctorId=null;queueItems=[];els.dashboardView.classList.add("d-none");els.loginView.classList.remove("d-none");els.doctorIdInput.value="1";}

els.openDoctorBtn.addEventListener("click",()=>startDashboard(els.doctorIdInput.value));
els.doctorIdInput.addEventListener("keydown",e=>{if(e.key==="Enter")startDashboard(els.doctorIdInput.value);});
els.logoutDoctorBtn.addEventListener("click",logoutDoctor);
els.refreshQueueBtn.addEventListener("click",()=>loadQueue(false));
els.callNextBtn.addEventListener("click",callNextPatient);
els.completePatientBtn.addEventListener("click",completeCurrentPatient);

const stored=sessionStorage.getItem(STORAGE_KEY);
if(stored){try{const saved=JSON.parse(stored);if(saved?.doctor_id)startDashboard(saved.doctor_id);}catch{sessionStorage.removeItem(STORAGE_KEY);}}
})();