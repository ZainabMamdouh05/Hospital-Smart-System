document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("loginForm");
  const input = document.getElementById("nationalId");
  const alertBox = document.getElementById("loginAlert");
  const button = document.getElementById("loginBtn");
  const buttonText = document.getElementById("loginText");
  const spinner = document.getElementById("loginSpinner");

  input.addEventListener("input", () => {
    input.value = input.value.replace(/\D/g, "").slice(0, 9);
    alertBox.className = "alert d-none";
    alertBox.textContent = "";
  });

  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    const nationalId = input.value.trim();

    if (!/^\d{9}$/.test(nationalId)) {
      alertBox.className = "alert alert-danger";
      alertBox.textContent = "يرجى إدخال رقم هوية صحيح مكوّن من 9 أرقام.";
      input.focus();
      return;
    }

    button.disabled = true;
    buttonText.classList.add("d-none");
    spinner.classList.remove("d-none");
    alertBox.className = "alert d-none";

    try {
      const raw = await lookupPatient(nationalId);
      const patient = firstObject(raw);

      if (!patient || !(patient.patient_id ?? patient.id)) {
        throw new Error("لم يتم العثور على مريض مرتبط برقم الهوية.");
      }

      sessionStorage.setItem(STORAGE_KEY, JSON.stringify({
        patient_id: patient.patient_id ?? patient.id,
        full_name: patient.patient_name ?? patient.full_name ?? patient.name ?? "المريض",
        national_id: patient.national_id ?? nationalId
      }));

      window.location.href = "patient.html";
    } catch (error) {
      console.error("Lookup Patient Error:", error);
      alertBox.className = "alert alert-danger";
      alertBox.textContent = error.message || "تعذر تسجيل الدخول الآن.";
    } finally {
      button.disabled = false;
      buttonText.classList.remove("d-none");
      spinner.classList.add("d-none");
    }
  });
});
