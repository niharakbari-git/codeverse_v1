<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Charge Card</title>
<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    background: radial-gradient(circle at top left, #1f2937, #111827 45%, #0b1220);
    color: #e5e7eb;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
}

.card {
    width: 100%;
    max-width: 460px;
    background: rgba(17, 24, 39, 0.9);
    border: 1px solid rgba(148, 163, 184, 0.22);
    border-radius: 16px;
    padding: 28px;
    box-shadow: 0 18px 45px rgba(0, 0, 0, 0.35);
}

.title {
    margin: 0 0 6px;
    font-size: 24px;
    font-weight: 700;
}

.subtitle {
    margin: 0 0 22px;
    color: #94a3b8;
    font-size: 14px;
}

.alert {
    border-radius: 10px;
    padding: 10px 12px;
    margin-bottom: 14px;
    font-size: 14px;
}

.alert-success {
    color: #bbf7d0;
    background: rgba(22, 163, 74, 0.18);
    border: 1px solid rgba(34, 197, 94, 0.35);
}

.alert-error {
    color: #fecaca;
    background: rgba(220, 38, 38, 0.18);
    border: 1px solid rgba(248, 113, 113, 0.35);
}

.field {
    margin-bottom: 14px;
}

.field label {
    display: block;
    margin-bottom: 6px;
    font-size: 13px;
    color: #cbd5e1;
    font-weight: 600;
}

.input {
    width: 100%;
    border: 1px solid rgba(148, 163, 184, 0.3);
    border-radius: 10px;
    background: rgba(15, 23, 42, 0.7);
    color: #f8fafc;
    padding: 11px 12px;
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
}

.input:focus {
    border-color: #60a5fa;
    box-shadow: 0 0 0 3px rgba(96, 165, 250, 0.22);
}

.grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
}

.btn {
    width: 100%;
    margin-top: 8px;
    border: none;
    border-radius: 10px;
    background: linear-gradient(135deg, #2563eb, #1d4ed8);
    color: white;
    font-size: 15px;
    font-weight: 700;
    padding: 12px;
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
}

.btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 8px 20px rgba(37, 99, 235, 0.35);
}

@media (max-width: 480px) {
    .card {
        padding: 22px;
    }

    .grid {
        grid-template-columns: 1fr;
    }
}
</style>
</head>
<body>
	<div class="card">
		<h1 class="title">Card Payment</h1>
		<p class="subtitle">Enter card details to continue.</p>

		<c:if test="${status == 'success'}">
			<div class="alert alert-success">${message}</div>
		</c:if>
		<c:if test="${status == 'error'}">
			<div class="alert alert-error">${message}</div>
		</c:if>

		<form action="<c:url value='/charge' />" method="post" autocomplete="off">
			<div class="field">
				<label for="amount">Amount</label>
				<input class="input" id="amount" type="number" min="1" step="0.01" name="amount" placeholder="e.g. 499.00" required>
			</div>

			<div class="field">
				<label for="cardNumber">Card Number</label>
				<input class="input" id="cardNumber" type="text" name="cardNumber" inputmode="numeric" maxlength="19" placeholder="1234 5678 9012 3456" required>
			</div>

			<div class="grid">
				<div class="field">
					<label for="expMonth">Expiry Month</label>
					<input class="input" id="expMonth" type="text" name="expMonth" maxlength="2" placeholder="MM" required>
				</div>
				<div class="field">
					<label for="expYear">Expiry Year</label>
					<input class="input" id="expYear" type="text" name="expYear" maxlength="4" placeholder="YYYY" required>
				</div>
			</div>

			<div class="field">
				<label for="cvv">CVV</label>
				<input class="input" id="cvv" type="password" name="cvv" maxlength="4" inputmode="numeric" placeholder="123" required>
			</div>

			<button class="btn" type="submit">Pay Now</button>
		</form>
	</div>

</body>
</html>