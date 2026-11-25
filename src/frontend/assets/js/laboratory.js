(() => {
"use strict";

const API_BASE="https://sprang-hesitancy-unwanted.ngrok-free.dev/webhook";

const els={
invoiceForm:document.getElementById("invoiceForm"),
nationalId:document.getElementById("nationalId"),
description:document.getElementById("description"),
amount:document.getElementById("amount"),
createInvoiceBtn:document.getElementById("createInvoiceBtn"),
refreshBtn:document.getElementById("refreshBtn"),
orders:document.getElementById("orders"),
empty:document.getElementById("empty"),
loading:document.getElementById("loading"),
alertBox:document.getElementById("alertBox"),
pendingPaymentCount:document.getElementById("pendingPaymentCount"),
readyCount:document.getElementById("readyCount"),
totalCount:document.getElementById("totalCount")
};

let invoices=[];
let busy=false;

function escapeHtml(v){return String(v??"").replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll('"',"&quot;").replaceAll("'","&#039;");}

function asArray(raw){
if(Array.isArray(raw))return raw;
if(Array.isArray(raw?.data))return raw.data;
if(Array.isArray(raw?.invoices))return raw.invoices;
if(raw&&typeof raw==="object"&&Object.keys(raw).length)return[raw];
return[];
}

async function api(path,options={}){
const res=await fetch(`${API_BASE}/${path}`,{
...options,
headers:{
"Content-Type":"application/json",
"ngrok-skip-browser-warning":"1",
...(options.headers||{})
}
});
const text=await res.text();
let data=null;
try{data=text?JSON.parse(text):null}catch{throw new Error(text||`HTTP ${res.status}`);}
if(!res.ok)throw new Error(data?.message||`HTTP ${res.status}`);
return data;
}

function showAlert(message,type="danger"){
els.alertBox.className=`alert alert-${type} mt-4`;
els.alertBox.textContent=message;
}
function clearAlert(){els.alertBox.className="alert d-none mt-4";els.alertBox.textContent="";}

function statusInfo(invoice){
const status=String(invoice.status??"").trim();
const fulfillment=String(invoice.fulfillment_status??"Pending").trim();

if(status==="Paid" && fulfillment!=="Completed"){
return {text:"تم الدفع ✅ — جاهزة للتنفيذ",className:"status-paid",ready:true};
}
if(status==="Pending"){
return {text:"بانتظار الدفع ⏳",className:"status-pending",ready:false};
}
if(fulfillment==="Completed"){
return {text:"تم التنفيذ ✅",className:"status-completed",ready:false};
}
return {text:status||"—",className:"status-pending",ready:false};
}

function render(){
const pending=invoices.filter(x=>String(x.status)==="Pending" && String(x.fulfillment_status??"Pending")!=="Completed").length;
const ready=invoices.filter(x=>String(x.status)==="Paid" && String(x.fulfillment_status??"Pending")!=="Completed").length;

els.pendingPaymentCount.textContent=pending;
els.readyCount.textContent=ready;
els.totalCount.textContent=invoices.length;

els.empty.classList.toggle("d-none",invoices.length>0);

els.orders.innerHTML=invoices.map(inv=>{
const id=inv.id??inv.invoice_id;
const info=statusInfo(inv);
const completed=String(inv.fulfillment_status??"Pending")==="Completed";

return `<article class="invoice-card">
<div class="row g-3 align-items-center">
<div class="col-lg-6">
<div class="d-flex flex-wrap gap-2 mb-2">
<span class="badge rounded-pill bg-light text-dark border">مختبر</span>
<span class="badge rounded-pill ${info.className}">${info.text}</span>
</div>
<div class="fw-bold">${escapeHtml(inv.invoice_number??id??"—")}</div>
<div class="small text-secondary mt-1">${escapeHtml(inv.description??"طلب مختبر")}</div>
<div class="small text-secondary mt-1">المريض: <strong>${escapeHtml(inv.patient_name??"—")}</strong> · الهوية: ${escapeHtml(inv.national_id??"—")}</div>
</div>
<div class="col-lg-2">
<div class="label">المبلغ</div>
<div class="amount">${escapeHtml(inv.amount??"—")} ₪</div>
</div>
<div class="col-lg-4 text-lg-start">
${
info.ready
? `<button class="btn btn-success w-100 complete-btn" data-id="${escapeHtml(id)}">تسليم / تنفيذ الفحص</button>`
: completed
? `<button class="btn btn-outline-secondary w-100" disabled>تم التنفيذ</button>`
: `<button class="btn btn-outline-secondary w-100" disabled>متاح بعد اعتماد الدفع</button>`
}
</div>
</div>
</article>`;
}).join("");
}

async function loadInvoices(silent=false){
if(busy)return;
busy=true;
if(!silent)els.loading.classList.remove("d-none");

try{
const raw=await api("laboratory/orders");
invoices=asArray(raw)
.filter(x=>String(x.invoice_type??"Laboratory").toLowerCase()==="laboratory")
.filter(x=>String(x.fulfillment_status??"Pending")!=="Completed");
render();
clearAlert();
}catch(error){
if(!silent)showAlert(error.message||"تعذر تحميل فواتير المختبر.");
}finally{
els.loading.classList.add("d-none");
busy=false;
}
}

async function createInvoice(event){
event.preventDefault();

const nationalId=els.nationalId.value.trim();
const description=els.description.value.trim();
const amount=Number(els.amount.value);

if(!/^\d{9}$/.test(nationalId)){
showAlert("أدخلي رقم هوية مكوّنًا من 9 أرقام.");
return;
}
if(!description){
showAlert("أدخلي وصف الفحص.");
return;
}
if(!Number.isFinite(amount)||amount<=0){
showAlert("أدخلي مبلغًا صحيحًا.");
return;
}

els.createInvoiceBtn.disabled=true;
els.createInvoiceBtn.textContent="جاري إنشاء الفاتورة...";

try{
const raw=await api("staff/create-invoice",{
method:"POST",
body:JSON.stringify({
national_id:nationalId,
invoice_type:"Laboratory",
description,
amount
})
});

if(raw?.success===false)throw new Error(raw.message||"تعذر إنشاء الفاتورة.");

els.invoiceForm.reset();
await loadInvoices(true);
showAlert(raw?.message||"تم إنشاء الفاتورة بنجاح ✅","success");
}catch(error){
showAlert(error.message||"تعذر إنشاء الفاتورة.");
}finally{
els.createInvoiceBtn.disabled=false;
els.createInvoiceBtn.textContent="إنشاء الفاتورة";
}
}

async function completeInvoice(id,button){
button.disabled=true;
button.textContent="جاري تأكيد التنفيذ...";

try{
const raw=await api("staff/complete-fulfillment",{
method:"POST",
body:JSON.stringify({invoice_id:Number(id)})
});

if(raw?.success===false)throw new Error(raw.message||"تعذر تأكيد تنفيذ الفحص.");

await loadInvoices(true);
showAlert(raw?.message||"تم تأكيد تنفيذ الفحص وتسليمه للمريض ✅","success");
}catch(error){
showAlert(error.message||"تعذر تنفيذ الخدمة.");
button.disabled=false;
button.textContent="تسليم / تنفيذ الفحص";
}
}

els.invoiceForm.addEventListener("submit",createInvoice);
els.refreshBtn.addEventListener("click",()=>loadInvoices(false));

els.orders.addEventListener("click",event=>{
const button=event.target.closest(".complete-btn");
if(!button)return;
completeInvoice(button.dataset.id,button);
});

els.nationalId.addEventListener("input",()=>{
els.nationalId.value=els.nationalId.value.replace(/\D/g,"").slice(0,9);
});

loadInvoices(false);
setInterval(()=>loadInvoices(true),5000);
})();