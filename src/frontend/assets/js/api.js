async function apiRequest(path, options = {}) {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...options,
    headers: {
      ...(options.headers || {}),
      "ngrok-skip-browser-warning": "1"
    }
  });

  const text = await response.text();
  let data = null;
  try {
    data = text ? JSON.parse(text) : null;
  } catch {
    data = { raw: text };
  }

  if (!response.ok) {
    throw new Error(data?.message || `HTTP ${response.status}`);
  }

  return data;
}

function firstObject(data) {
  if (Array.isArray(data)) return data[0] ?? null;
  if (data?.data && Array.isArray(data.data)) return data.data[0] ?? null;
  return data ?? null;
}

function dataArray(data, keys = []) {
  if (Array.isArray(data)) return data;
  for (const key of keys) {
    if (Array.isArray(data?.[key])) return data[key];
  }
  if (data && typeof data === "object" && Object.keys(data).length && !data.success) {
    return [data];
  }
  return [];
}

async function lookupPatient(nationalId) {
  return apiRequest("/patient/lookup", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ national_id: nationalId })
  });
}

async function getClinics() {
  return apiRequest("/patient/clinics");
}

async function getCurrentDoctor(clinicId) {
  return apiRequest(`/patient/current-doctor?clinic_id=${encodeURIComponent(clinicId)}`);
}

async function createClinicBooking(nationalId, clinicId) {
  return apiRequest("/patient/take-queue", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ national_id: nationalId, clinic_id: Number(clinicId) })
  });
}

async function getPendingInvoices(nationalId) {
  return apiRequest(`/patient/pending-invoices?national_id=${encodeURIComponent(nationalId)}`);
}

async function submitPayment({ nationalId, invoiceId, senderName, senderPhone, receiptFile }) {
  const form = new FormData();
  form.append("national_id", nationalId);
  form.append("invoice_id", String(invoiceId));
  form.append("sender_name", senderName);
  form.append("sender_phone", senderPhone);
  form.append("receipt", receiptFile);

  return apiRequest("/patient/submit-payment", {
    method: "POST",
    body: form
  });
}

async function getQueueStatus(nationalId) {
  return apiRequest(`/patient/queue-status?national_id=${encodeURIComponent(nationalId)}`);
}
