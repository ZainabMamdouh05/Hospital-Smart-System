document.addEventListener("DOMContentLoaded", () => {
  const stored = sessionStorage.getItem(STORAGE_KEY);
  if (!stored) {
    window.location.href = "index.html";
    return;
  }

  let patient;
  try {
    patient = JSON.parse(stored);
  } catch {
    sessionStorage.removeItem(STORAGE_KEY);
    window.location.href = "index.html";
    return;
  }

  const els = {
    navPatientName: document.getElementById("navPatientName"),
    heroPatientName: document.getElementById("heroPatientName"),
    heroNationalId: document.getElementById("heroNationalId"),
    pageAlert: document.getElementById("pageAlert"),
    clinicSearch: document.getElementById("clinicSearch"),
    clinicCount: document.getElementById("clinicCount"),
    clinicsGrid: document.getElementById("clinicsGrid"),
    clinicsLoading: document.getElementById("clinicsLoading"),
    clinicsEmpty: document.getElementById("clinicsEmpty"),
    invoicesList: document.getElementById("invoicesList"),
    invoicesLoading: document.getElementById("invoicesLoading"),
    invoicesEmpty: document.getElementById("invoicesEmpty"),
    queueCard: document.getElementById("queueCard"),
    queueLoading: document.getElementById("queueLoading"),
    queueEmpty: document.getElementById("queueEmpty")
  };

  const bookingModal = new bootstrap.Modal(document.getElementById("bookingModal"));
  const paymentModal = new bootstrap.Modal(document.getElementById("paymentModal"));
  const toast = new bootstrap.Toast(document.getElementById("appToast"));

  let clinicsCache = [];
  let selectedClinic = null;
  let selectedInvoice = null;

  els.navPatientName.textContent = patient.full_name || "المريض";
  els.heroPatientName.textContent = patient.full_name || "المريض";
  els.heroNationalId.textContent = patient.national_id || "—";

  function showPageAlert(message, type = "danger") {
    els.pageAlert.className = `alert alert-${type}`;
    els.pageAlert.textContent = message;
  }

  function clearPageAlert() {
    els.pageAlert.className = "alert d-none";
    els.pageAlert.textContent = "";
  }

  function escapeHtml(value) {
    return String(value ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }

  const iconMap = {
    "الأسنان": "🦷",
    "الجراحة العامة": "🩺",
    "الباطنة": "🫀",
    "المخ والأعصاب": "🧠",
    "المسالك البولية": "💧",
    "الجهاز الهضمي": "🫁",
    "العظام": "🦴",
    "العظام والأعصاب الطرفية": "🦴",
    "أنف وأذن وحنجرة": "👂",
    "السكري والغدد": "🧬",
    "الجلدية": "✨",
    "جراحة الشرج والمستقيم": "🩺",
    "العيون": "👁️",
    "جراحة الأطفال": "🧒",
    "النساء والحوامل": "🤍",
    "التجميل والليزر": "✨"
  };

  function clinicCard(clinic) {
    const clinicId = clinic.id ?? clinic.clinic_id;
    const name = clinic.name ?? clinic.clinic_name ?? "عيادة";
    const description = clinic.description ?? `حجز ${name}`;
    const fee = Number(clinic.consultation_fee ?? 0);
    const feeText = Number.isFinite(fee) && fee > 0 ? `${fee.toFixed(2)} شيكل` : "يظهر عند الاختيار";
    const icon = iconMap[name] ?? "✚";

    return `
      <div class="col-12 col-md-6 col-xl-4">
        <article class="clinic-card">
          <div class="clinic-card-top">
            <div class="clinic-icon" aria-hidden="true">${icon}</div>
            <div class="clinic-title-wrap">
              <h3>${escapeHtml(name)}</h3>
              <p>${escapeHtml(description)}</p>
            </div>
            <span class="clinic-arrow" aria-hidden="true">←</span>
          </div>
          <div class="clinic-card-bottom">
            <div class="fee-text">رسوم الاستشارة<br><strong>${escapeHtml(feeText)}</strong></div>
            <button class="btn btn-primary book-clinic-btn" type="button" data-clinic-id="${escapeHtml(clinicId)}" data-clinic-name="${escapeHtml(name)}" data-clinic-fee="${Number.isFinite(fee) ? fee : 0}">
              عرض التفاصيل
            </button>
          </div>
        </article>
      </div>
    `;
  }

  function renderClinics() {
    const query = els.clinicSearch.value.trim().toLowerCase();
    const filtered = clinicsCache.filter((clinic) => {
      const name = String(clinic.name ?? clinic.clinic_name ?? "").toLowerCase();
      const desc = String(clinic.description ?? "").toLowerCase();
      return !query || name.includes(query) || desc.includes(query);
    });

    els.clinicCount.textContent = `${filtered.length} عيادة`;
    els.clinicsGrid.innerHTML = filtered.map(clinicCard).join("");
    els.clinicsEmpty.textContent = query ? "لم نجد عيادة مطابقة لبحثك." : "لا توجد عيادات متاحة حاليًا.";
    els.clinicsEmpty.classList.toggle("d-none", filtered.length > 0);
  }

  function invoiceCard(invoice) {
    const id = invoice.id ?? invoice.invoice_id;
    const hasPendingPayment = Number(invoice.pending_payment_count) > 0;
    const statusText = hasPendingPayment ? "قيد مراجعة الدفع" : "بانتظار الدفع";
    const isClinic = String(invoice.invoice_type ?? "").toLowerCase() === "clinic";

    return `
      <article class="invoice-card">
        <div class="row align-items-center g-3">
          <div class="col-lg-7">
            <div class="d-flex align-items-center flex-wrap gap-2 mb-1">
              <span class="badge rounded-pill ${isClinic ? "text-bg-primary" : "text-bg-light border"}">${escapeHtml(invoice.invoice_type ?? "فاتورة")}</span>
              <span class="invoice-number">${escapeHtml(invoice.invoice_number ?? id)}</span>
            </div>
            <div class="invoice-title">${escapeHtml(invoice.description ?? "فاتورة مستحقة")}</div>
            ${invoice.clinic_name ? `<div class="invoice-meta mt-1">${escapeHtml(invoice.clinic_name)}${invoice.doctor_name ? ` · ${escapeHtml(invoice.doctor_name)}` : ""}</div>` : ""}
          </div>
          <div class="col-lg-2">
            <div class="invoice-number">المبلغ</div>
            <div class="invoice-amount">${escapeHtml(invoice.amount ?? "—")} ₪</div>
          </div>
          <div class="col-lg-3 d-flex align-items-center justify-content-lg-end gap-2 flex-wrap">
            <span class="badge rounded-pill pending-badge">${statusText}</span>
            ${!hasPendingPayment ? `<button class="btn btn-outline-primary pay-invoice-btn" type="button" data-invoice-id="${escapeHtml(id)}">رفع الإيصال</button>` : ""}
          </div>
        </div>
      </article>
    `;
  }

  function renderQueue(rawQueue) {
    const item = firstObject(rawQueue);
    if (!item || !(item.booking_id ?? item.id)) {
      els.queueEmpty.classList.remove("d-none");
      els.queueCard.classList.add("d-none");
      return;
    }

    els.queueEmpty.classList.add("d-none");
    els.queueCard.classList.remove("d-none");

    const yourNumber = item.your_queue_number ?? item.queue_number ?? "—";
    const current = item.current_queue_number ?? 0;
    const ahead = item.people_ahead ?? 0;
    const status = item.your_status ?? item.status ?? "Waiting";
    const statusArabic = status === "Serving" ? "جاري خدمتك" : "بانتظار الدور";

    els.queueCard.innerHTML = `
      <article class="queue-card">
        <div class="row g-4 align-items-center">
          <div class="col-md-5">
            <div class="small text-white-50 mb-2">رقم دورك</div>
            <div class="queue-number">${escapeHtml(yourNumber)}</div>
            <span class="badge text-bg-light mt-2">${statusArabic}</span>
          </div>
          <div class="col-md-7">
            <div class="row g-3">
              <div class="col-6">
                <div class="metric-label">الدور الحالي</div>
                <div class="metric-value">${escapeHtml(current)}</div>
              </div>
              <div class="col-6">
                <div class="metric-label">أمامك</div>
                <div class="metric-value">${escapeHtml(ahead)}</div>
              </div>
              <div class="col-12">
                <div class="small text-white-50">${escapeHtml(item.clinic_name ?? "")} ${item.doctor_name ? ` · ${escapeHtml(item.doctor_name)}` : ""}</div>
              </div>
            </div>
          </div>
        </div>
      </article>
    `;
  }

  async function loadClinics() {
    clearPageAlert();
    els.clinicsLoading.innerHTML = '<div class="skeleton"></div><div class="skeleton"></div><div class="skeleton"></div>';
    els.clinicsGrid.innerHTML = "";
    els.clinicsEmpty.classList.add("d-none");

    try {
      const raw = await getClinics();
      clinicsCache = dataArray(raw, ["clinics", "data"]);
      els.clinicsLoading.innerHTML = "";
      renderClinics();
    } catch (error) {
      els.clinicsLoading.innerHTML = "";
      els.clinicCount.textContent = "—";
      showPageAlert(error.message || "تعذر تحميل العيادات.");
    }
  }

  let invoicesLoadingInProgress = false;

async function loadInvoices(silent = false) {
  if (invoicesLoadingInProgress) return;
  invoicesLoadingInProgress = true;

  if (!silent) {
    els.invoicesLoading.innerHTML =
      '<div class="skeleton wide"></div><div class="skeleton wide"></div>';
    els.invoicesList.innerHTML = "";
    els.invoicesEmpty.classList.add("d-none");
  }

  try {
    const raw = await getPendingInvoices(patient.national_id);
    const invoices = dataArray(raw, ["invoices", "data"]);

    els.invoicesLoading.innerHTML = "";

    if (!invoices.length) {
      els.invoicesList.innerHTML = "";
      els.invoicesEmpty.classList.remove("d-none");
      return;
    }

    els.invoicesEmpty.classList.add("d-none");
    els.invoicesList.innerHTML = invoices.map(invoiceCard).join("");

  } catch (error) {
    if (!silent) {
      els.invoicesLoading.innerHTML = "";
      showPageAlert(error.message || "تعذر تحميل الفواتير.");
    }
  } finally {
    invoicesLoadingInProgress = false;
  }
}

  let queueLoadingInProgress = false;

async function loadQueue(silent = false) {
  if (queueLoadingInProgress) return;
  queueLoadingInProgress = true;

  if (!silent) {
    els.queueLoading.innerHTML = '<div class="skeleton wide"></div>';
    els.queueEmpty.classList.add("d-none");
  }

  try {
    const raw = await getQueueStatus(patient.national_id);

    els.queueLoading.innerHTML = "";
    renderQueue(raw);

  } catch (error) {
    if (!silent) {
      els.queueLoading.innerHTML = "";
      els.queueEmpty.classList.remove("d-none");
      els.queueCard.classList.add("d-none");
    }
  } finally {
    queueLoadingInProgress = false;
  }
}

  function showToast(message) {
    document.getElementById("toastBody").textContent = message;
    toast.show();
  }

  function openPaymentModal(invoice) {
    selectedInvoice = invoice;
    document.getElementById("paymentInvoiceSummary").innerHTML = `
      <div class="d-flex justify-content-between align-items-start gap-3">
        <div>
          <div class="summary-label">رقم الفاتورة</div>
          <div class="fw-bold">${escapeHtml(invoice.invoice_number ?? invoice.id)}</div>
          <div class="invoice-meta mt-2">${escapeHtml(invoice.description ?? "")}</div>
        </div>
        <div class="text-start">
          <div class="summary-label">المبلغ</div>
          <div class="fs-4 fw-bold">${escapeHtml(invoice.amount ?? "—")} ₪</div>
        </div>
      </div>
    `;
    document.getElementById("paymentAlert").className = "alert d-none";
    document.getElementById("senderName").value = patient.full_name || "";
    document.getElementById("senderPhone").value = "";
    document.getElementById("receiptFile").value = "";
    paymentModal.show();
  }

  document.getElementById("logoutBtn").addEventListener("click", () => {
    sessionStorage.removeItem(STORAGE_KEY);
    window.location.href = "index.html";
  });

  document.getElementById("refreshClinicsBtn").addEventListener("click", loadClinics);
  document.getElementById("refreshInvoicesBtn").addEventListener("click", loadInvoices);
  document.getElementById("refreshQueueBtn").addEventListener("click", loadQueue);
  els.clinicSearch.addEventListener("input", renderClinics);

  els.clinicsGrid.addEventListener("click", async (event) => {
    const button = event.target.closest(".book-clinic-btn");
    if (!button) return;

    selectedClinic = {
      clinic_id: Number(button.dataset.clinicId),
      clinic_name: button.dataset.clinicName,
      consultation_fee: Number(button.dataset.clinicFee || 0)
    };

    const alertBox = document.getElementById("bookingAlert");
    const summary = document.getElementById("bookingSummary");
    const confirmButton = document.getElementById("confirmBookingBtn");

    alertBox.className = "alert d-none";
    confirmButton.disabled = true;
    summary.innerHTML = `
      <div class="booking-summary-title">
        <span class="summary-label">العيادة المختارة</span>
        <strong class="summary-value">${escapeHtml(selectedClinic.clinic_name)}</strong>
      </div>
      <div class="summary-loading mt-3">جاري التحقق من الطبيب وجدول اليوم...</div>
    `;
    bookingModal.show();

    try {
      const raw = await getCurrentDoctor(selectedClinic.clinic_id);
      const doctor = firstObject(raw);
      if (!doctor || !(doctor.doctor_name ?? doctor.doctor_id)) {
        throw new Error("لا يوجد طبيب أو موعد متاح لهذه العيادة الآن.");
      }

      const fee = Number(doctor.consultation_fee ?? selectedClinic.consultation_fee ?? 0);
      const feeText = Number.isFinite(fee) && fee > 0 ? `${fee.toFixed(2)} شيكل` : "غير محدد";

      summary.innerHTML = `
        <div class="booking-summary-title mb-3">
          <span class="summary-label">العيادة</span>
          <strong class="summary-value">${escapeHtml(selectedClinic.clinic_name)}</strong>
        </div>
        <div class="booking-info-grid">
          <div class="booking-info-item">
            <span class="summary-label">الطبيب الحالي</span>
            <strong>${escapeHtml(doctor.doctor_name)}</strong>
          </div>
          <div class="booking-info-item">
            <span class="summary-label">الفترة</span>
            <strong>${escapeHtml(doctor.shift ?? "—")}</strong>
          </div>
          <div class="booking-info-item">
            <span class="summary-label">موعد العيادة</span>
            <strong dir="ltr">${escapeHtml(doctor.start_time ?? "—")} - ${escapeHtml(doctor.end_time ?? "—")}</strong>
          </div>
          <div class="booking-info-item fee-highlight">
            <span class="summary-label">رسوم الحجز</span>
            <strong>${escapeHtml(feeText)}</strong>
          </div>
        </div>
        <div class="booking-note mt-3">سيتم إنشاء فاتورة بحالة انتظار الدفع، ولن يُمنح رقم دور قبل اعتماد الدفع.</div>
      `;
      confirmButton.disabled = false;
    } catch (error) {
      summary.innerHTML = `<div class="text-danger fw-semibold">${escapeHtml(error.message || "تعذر التحقق من الموعد.")}</div>`;
    }
  });

  document.getElementById("confirmBookingBtn").addEventListener("click", async () => {
    if (!selectedClinic) return;

    const button = document.getElementById("confirmBookingBtn");
    const alertBox = document.getElementById("bookingAlert");
    button.disabled = true;
    alertBox.className = "alert d-none";

    try {
      const result = await createClinicBooking(patient.national_id, selectedClinic.clinic_id);
      if (result?.success === false) throw new Error(result.message || "تعذر إنشاء الحجز.");

      const invoice = result.invoice ?? firstObject(result);
      bookingModal.hide();
      await loadInvoices();
      await loadQueue();

      if (invoice?.id ?? invoice?.invoice_id) {
        openPaymentModal(invoice);
      } else {
        showToast("تم إنشاء الفاتورة. افتحي قسم الفواتير لإرسال الإيصال.");
      }
    } catch (error) {
      alertBox.className = "alert alert-danger";
      alertBox.textContent = error.message || "تعذر إنشاء الحجز.";
      button.disabled = false;
    }
  });

  els.invoicesList.addEventListener("click", async (event) => {
    const button = event.target.closest(".pay-invoice-btn");
    if (!button) return;

    try {
      const raw = await getPendingInvoices(patient.national_id);
      const invoices = dataArray(raw, ["invoices", "data"]);
      const invoice = invoices.find(item => String(item.id ?? item.invoice_id) === String(button.dataset.invoiceId));
      if (!invoice) {
        showToast("الفاتورة لم تعد معلقة.");
        loadInvoices();
        return;
      }
      openPaymentModal(invoice);
    } catch (error) {
      showToast(error.message || "تعذر فتح الفاتورة.");
    }
  });

  document.getElementById("paymentForm").addEventListener("submit", async (event) => {
    event.preventDefault();
    if (!selectedInvoice) return;

    const file = document.getElementById("receiptFile").files[0];
    const senderName = document.getElementById("senderName").value.trim();
    const senderPhone = document.getElementById("senderPhone").value.trim();
    const alertBox = document.getElementById("paymentAlert");
    const button = document.getElementById("submitPaymentBtn");
    const text = document.getElementById("submitPaymentText");
    const spinner = document.getElementById("submitPaymentSpinner");

    if (!file || !senderName || !senderPhone) {
      alertBox.className = "alert alert-danger";
      alertBox.textContent = "أكملي اسم المُرسل ورقمه واختاري صورة الإيصال.";
      return;
    }

    button.disabled = true;
    text.classList.add("d-none");
    spinner.classList.remove("d-none");
    alertBox.className = "alert d-none";

    try {
      const result = await submitPayment({
        nationalId: patient.national_id,
        invoiceId: selectedInvoice.id ?? selectedInvoice.invoice_id,
        senderName,
        senderPhone,
        receiptFile: file
      });

      if (result?.success === false) throw new Error(result.message || "تعذر إرسال طلب الدفع.");

      paymentModal.hide();
      showToast("تم إرسال الإيصال للمراجعة عبر Telegram ✅");
      await loadInvoices();
    } catch (error) {
      alertBox.className = "alert alert-danger";
      alertBox.textContent = error.message || "تعذر إرسال الإيصال.";
    } finally {
      button.disabled = false;
      text.classList.remove("d-none");
      spinner.classList.add("d-none");
    }
  });

  clearPageAlert();

loadClinics();
loadInvoices();
loadQueue();

// تحديث الفواتير والدور تلقائيًا كل 5 ثوانٍ
setInterval(() => {
  loadInvoices(true);
  loadQueue(true);
}, 5000);
});
