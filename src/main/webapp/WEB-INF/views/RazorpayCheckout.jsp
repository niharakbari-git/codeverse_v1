<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Complete Payment | CodeVerse</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;700&family=Syne:wght@700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/neo-viva-theme.css?v=20260512c">
<script defer src="${pageContext.request.contextPath}/assets/js/neo-viva-theme.js?v=20260512c"></script>
<style>
.wrap{min-height:100vh;display:grid;place-items:center;padding:16px}
.card{width:min(760px,100%);padding:24px;display:grid;gap:14px}
.meta{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}
.meta > div{padding:10px 12px;border:1px solid #d7dce5;border-radius:12px;background:#fff}
.label{font-size:11px;font-weight:800;text-transform:uppercase;letter-spacing:.06em;color:#5e6673}
.value{margin-top:4px;font-weight:700;color:#1f2329}
.actions{display:flex;gap:10px;flex-wrap:wrap}
.hint{font-size:13px;color:#5e6673;line-height:1.5}
.upi-box{display:grid;gap:10px;padding:12px;border:1px solid #d7dce5;border-radius:12px;background:#f9fbff}
.upi-box input{border:1px solid #d7dce5;border-radius:10px;padding:9px 10px;background:#fff;font-size:14px;width:100%}
.upi-note{margin:0;font-size:12px;color:#6b7280}
@media(max-width:720px){.meta{grid-template-columns:1fr}}
</style>
<script src="${checkout.checkoutScriptUrl}"></script>
</head>
<body>
<div class="wrap">
  <div class="neo-panel card" data-reveal>
    <div class="neo-badge">Razorpay Checkout</div>
    <h1 class="neo-title">Complete your hackathon registration fee</h1>
    <p class="neo-sub">A secure checkout will open automatically. UPI is available by default.</p>

    <div class="meta">
      <div><div class="label">Hackathon</div><div class="value"><c:out value="${checkout.hackathonTitle}" /></div></div>
      <div><div class="label">Team</div><div class="value"><c:out value="${checkout.teamName}" /></div></div>
      <div><div class="label">Participant</div><div class="value"><c:out value="${checkout.participantName}" /></div></div>
      <div><div class="label">Amount</div><div class="value">Rs. <c:out value="${checkout.amountDisplay}" /></div></div>
      <div><div class="label">Order</div><div class="value"><c:out value="${checkout.orderId}" /></div></div>
      <div><div class="label">Currency</div><div class="value"><c:out value="${checkout.currency}" /></div></div>
    </div>

    <p id="checkout-status" class="hint">Opening secure checkout. If popup is blocked, use the button below.</p>

    <div class="upi-box">
      <label for="vpa-input" class="label" style="margin:0">UPI VPA</label>
      <input id="vpa-input" type="text" placeholder="example@bank" maxlength="255" autocomplete="off">
      <p class="upi-note">Optional. If filled, Razorpay opens the UPI flow with this VPA preselected.</p>
    </div>

    <div class="actions">
      <button id="open-checkout-btn" type="button">Open Checkout</button>
      <a class="btn" href="${checkout.cancelUrl}">Cancel</a>
      <a class="btn" href="${pageContext.request.contextPath}/participant/my-applications">Back to Applications</a>
    </div>

    <form id="payment-verify-form" action="${checkout.verifyUrl}" method="post" style="display:none">
      <input type="hidden" name="_csrf" value="${_csrfToken}">
      <input type="hidden" name="razorpay_order_id" id="razorpay_order_id">
      <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
      <input type="hidden" name="razorpay_signature" id="razorpay_signature">
    </form>

    <div id="toast-data" data-type="success" style="display:none;">Opening Razorpay checkout...</div>
  </div>
</div>

<script>
(function () {
  const PAGE_EXPIRES_AFTER_MS = 12 * 60 * 1000;
  const statusEl = document.getElementById('checkout-status');
  const openButton = document.getElementById('open-checkout-btn');
  const pageLoadedAt = Date.now();

  const vpaInput = document.getElementById('vpa-input');
  const vpaValue = vpaInput ? vpaInput.value.trim() : '';

  const options = {
    key: '<c:out value="${checkout.keyId}" />',
    amount: <c:out value="${checkout.amountPaise}" />,
    currency: '<c:out value="${checkout.currency}" />',
    name: 'CodeVerse',
    description: 'Hackathon registration fee',
    order_id: '<c:out value="${checkout.orderId}" />',
    handler: function (response) {
      document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
      document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
      document.getElementById('razorpay_signature').value = response.razorpay_signature;
      document.getElementById('payment-verify-form').submit();
    },
    prefill: {
      name: '<c:out value="${checkout.participantName}" />',
      email: '<c:out value="${checkout.participantEmail}" />',
      contact: '<c:out value="${checkout.participantContact}" />',
      method: 'upi'
    },
    theme: {
      color: '#1f2329'
    },
    modal: {
      escape: false,
      confirm_close: true,
      ondismiss: function () {
        window.location.href = '${checkout.cancelUrl}';
      }
    }
  };

  if (vpaValue) {
    options.prefill.vpa = vpaValue;
  }

  function checkoutHasExpired() {
    return (Date.now() - pageLoadedAt) > PAGE_EXPIRES_AFTER_MS;
  }

  function launchCheckout() {
    if (checkoutHasExpired()) {
      if (statusEl) {
        statusEl.textContent = 'This payment page expired for safety. Starting a fresh payment request...';
      }
      window.location.href = '${checkout.cancelUrl}?msg=Payment+page+expired.+Please+start+again&type=error';
      return;
    }
    if (statusEl) {
      statusEl.textContent = 'Secure checkout is open. Complete payment and return here automatically.';
    }
    const rzp = new Razorpay(options);
    rzp.on('payment.failed', function () {
      window.location.href = '${checkout.cancelUrl}?msg=Payment+failed+or+was+cancelled&type=error';
    });
    rzp.open();
  }

  if (openButton) {
    openButton.addEventListener('click', launchCheckout);
  }

  window.setTimeout(function () {
    if (!checkoutHasExpired()) {
      launchCheckout();
    }
  }, 350);

  window.setTimeout(function () {
    if (statusEl) {
      statusEl.textContent = 'For security, this page expires after a few minutes. If needed, click Open Checkout again.';
    }
  }, 10 * 1000);

  window.setTimeout(function () {
    if (checkoutHasExpired()) {
      if (statusEl) {
        statusEl.textContent = 'This payment page has expired. Start payment again from My Applications.';
      }
      if (openButton) {
        openButton.disabled = true;
      }
    }
  }, PAGE_EXPIRES_AFTER_MS + 250);
})();
</script>
</body>
</html>