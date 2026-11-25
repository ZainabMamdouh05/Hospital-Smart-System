const API_BASE = 'https://sprang-hesitancy-unwanted.ngrok-free.dev/webhook';

let loading = false;

function esc(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;');
}

function showAlert(message, type='success') {
  const box = document.getElementById('alertBox');
  box.innerHTML = `<div class="alert alert-${type} alert-dismissible fade show" role="alert">
    ${esc(message)}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="إغلاق"></button>
  </div>`;
}

function statusView(order) {
  if (order.status === 'Pending') {
    return '<span class="badge text-bg-warning">بانتظار الدفع</span>';
  }
  if (order.status === 'Paid' && order.fulfillment_status === 'Pending') {
    return '<span class="badge badge-soft">تم الدفع ✅ — جاهزة للصرف</span>';
  }
  return `<span class="badge text-bg-secondary">${esc(order.status)}</span>`;
}

function actionView(order) {
  if (order.status === 'Paid' && order.fulfillment_status === 'Pending') {
    return `<button class="btn btn-success btn-sm" onclick="completeFulfillment(${Number(order.invoice_id)})">صرف / تسليم الدواء</button>`;
  }
  if (order.status === 'Pending') {
    return '<button class="btn btn-outline-secondary btn-sm" disabled>متاح بعد اعتماد الدفع</button>';
  }
  return '<span class="text-muted">—</span>';
}

function renderOrders(orders) {
  const body = document.getElementById('ordersBody');
  const empty = document.getElementById('emptyState');
  const safeOrders = Array.isArray(orders) ? orders : [];

  document.getElementById('pendingCount').textContent = safeOrders.filter(o => o.status === 'Pending').length;
  document.getElementById('paidCount').textContent = safeOrders.filter(o => o.status === 'Paid' && o.fulfillment_status === 'Pending').length;
  document.getElementById('totalCount').textContent = safeOrders.length;

  if (!safeOrders.length) {
    body.innerHTML = '';
    empty.classList.remove('d-none');
    return;
  }
  empty.classList.add('d-none');

  body.innerHTML = safeOrders.map(order => `
    <tr>
      <td><strong>${esc(order.invoice_number || ('#' + order.invoice_id))}</strong></td>
      <td>
        <div>${esc(order.patient_name)}</div>
        <small class="text-muted">${esc(order.national_id)}</small>
      </td>
      <td>${esc(order.description)}</td>
      <td>${esc(order.amount)} ₪</td>
      <td>${statusView(order)}</td>
      <td>${actionView(order)}</td>
    </tr>
  `).join('');
}

async function loadOrders(silent=false) {
  if (loading) return;
  loading = true;
  try {
   const response = await fetch(`${API_BASE}/pharmacy/orders`, {
  cache: 'no-store',
  headers: {
    'ngrok-skip-browser-warning': '1'
  }
});
    const payload = await response.json();
    renderOrders(payload?.data || []);
  } catch (error) {
    if (!silent) showAlert('تعذر تحميل طلبات الصيدلية. تأكدي أن رابط n8n والـ workflow شغالين.', 'danger');
  } finally {
    loading = false;
  }
}

async function createInvoice(event) {
  event.preventDefault();
  const btn = document.getElementById('createBtn');
  const national_id = document.getElementById('nationalId').value.trim();
  const description = document.getElementById('description').value.trim();
  const amount = Number(document.getElementById('amount').value);

  if (!national_id || !description || !Number.isFinite(amount) || amount <= 0) {
    showAlert('عبّي البيانات بشكل صحيح.', 'warning');
    return;
  }

  btn.disabled = true;
  btn.textContent = 'جاري الإنشاء...';

  try {
    const response = await fetch(`${API_BASE}/staff/create-invoice`, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        national_id,
        invoice_type: 'Pharmacy',
        description,
        amount
      })
    });

    const payload = await response.json().catch(() => ({}));
    if (!response.ok) throw new Error(payload?.message || `HTTP ${response.status}`);

    showAlert(`تم إنشاء الفاتورة ${payload?.data?.invoice_number || ''} بنجاح.`);
    document.getElementById('invoiceForm').reset();
    await loadOrders(true);
  } catch (error) {
    showAlert(error.message || 'حدث خطأ أثناء إنشاء الفاتورة.', 'danger');
  } finally {
    btn.disabled = false;
    btn.textContent = 'إنشاء الفاتورة';
  }
}

async function completeFulfillment(invoiceId) {
  if (!Number.isInteger(Number(invoiceId))) return;
  try {
    const response = await fetch(`${API_BASE}/staff/complete-fulfillment`, {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ invoice_id: Number(invoiceId) })
    });

    const payload = await response.json().catch(() => ({}));
    if (!response.ok) throw new Error(payload?.message || `HTTP ${response.status}`);

    showAlert('تم تسجيل صرف / تسليم الدواء بنجاح.');
    await loadOrders(true);
  } catch (error) {
    showAlert(error.message || 'تعذر تسجيل إتمام الطلب.', 'danger');
  }
}

window.completeFulfillment = completeFulfillment;

document.getElementById('invoiceForm').addEventListener('submit', createInvoice);
document.getElementById('refreshBtn').addEventListener('click', () => loadOrders(false));

loadOrders(false);
setInterval(() => loadOrders(true), 5000);
