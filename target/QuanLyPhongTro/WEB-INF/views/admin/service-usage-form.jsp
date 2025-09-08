<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản lý Phòng trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            border-radius: 10px;
            margin: 2px 0;
        }
        
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
        }
        
        .main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            color: white;
        }
        
        .btn-custom:hover {
            background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
            color: white;
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-box {
            background: linear-gradient(135deg, #e3f2fd, #f3e5f5);
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .service-info {
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }
        
        .calculation-box {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            border-radius: 10px;
            border: 1px solid #ffc107;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 sidebar">
                <div class="d-flex flex-column p-3">
                    <div class="text-center mb-4">
                        <i class="bi bi-building fs-1 text-white"></i>
                        <h4 class="text-white">Admin Panel</h4>
                    </div>
                    
                    <nav class="nav nav-pills flex-column">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                            <i class="bi bi-speedometer2 me-2"></i>Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/rooms" class="nav-link">
                            <i class="bi bi-door-open me-2"></i>Phòng trọ
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/tenants" class="nav-link">
                            <i class="bi bi-people me-2"></i>Người thuê
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/services" class="nav-link">
                            <i class="bi bi-tools me-2"></i>Dịch vụ
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/service-usage" class="nav-link active">
                            <i class="bi bi-graph-up me-2"></i>Sử dụng DV
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/additional-costs" class="nav-link">
                            <i class="bi bi-plus-circle me-2"></i>Chi phí PS
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/bills" class="nav-link">
                            <i class="bi bi-receipt me-2"></i>Hóa đơn
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                            <i class="bi bi-person-gear me-2"></i>Người dùng
                        </a>
                        <hr class="text-white">
                        <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                            <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content p-4">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2><i class="bi bi-graph-up me-2"></i>${pageTitle}</h2>
                        <p class="text-muted mb-0">Nhập thông tin sử dụng dịch vụ hàng tháng</p>
                    </div>
                    <div class="text-end">
                        <span class="text-muted">Xin chào, </span>
                        <strong>${user.fullName}</strong>
                    </div>
                </div>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Service Usage Form -->
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header py-3">
                                <h5 class="mb-0">
                                    <i class="bi bi-file-earmark-plus me-2"></i>
                                    <c:choose>
                                        <c:when test="${action == 'edit'}">Chỉnh sửa</c:when>
                                        <c:otherwise>Thêm mới</c:otherwise>
                                    </c:choose>
                                    Sử dụng dịch vụ
                                </h5>
                            </div>
                            <div class="card-body">
                                <!-- Info Box -->
                                <div class="info-box p-3 mb-4">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-info-circle fs-3 text-primary me-3"></i>
                                        <div>
                                            <h6 class="mb-1">Hướng dẫn nhập liệu:</h6>
                                            <small class="text-muted">
                                                • Chọn người thuê và dịch vụ tương ứng<br>
                                                • Nhập số lượng sử dụng (ví dụ: kWh cho điện, m³ cho nước)<br>
                                                • Hệ thống sẽ tự động tính thành tiền dựa trên đơn giá
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                
                                <c:set var="formAction" value="${action == 'edit' ? '/admin/service-usage/edit/' += serviceUsage.usageId : '/admin/service-usage/add'}" />
                                
                                <form action="${pageContext.request.contextPath}${formAction}" method="POST" id="serviceUsageForm">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="tenantId" class="form-label">
                                                    <i class="bi bi-person me-1"></i>Người thuê <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="tenantId" name="tenantId" required onchange="updateTenantInfo()">
                                                    <option value="">-- Chọn người thuê --</option>
                                                    <c:forEach var="tenant" items="${tenants}">
                                                        <option value="${tenant.tenantId}" 
                                                                data-name="${tenant.fullName}"
                                                                data-room="${tenant.roomName}"
                                                                data-phone="${tenant.phone}"
                                                                ${action == 'edit' && serviceUsage.tenantId == tenant.tenantId ? 'selected' : ''}>
                                                            ${tenant.fullName} - ${tenant.roomName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="serviceId" class="form-label">
                                                    <i class="bi bi-tools me-1"></i>Dịch vụ <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="serviceId" name="serviceId" required onchange="updateServiceInfo()">
                                                    <option value="">-- Chọn dịch vụ --</option>
                                                    <c:forEach var="service" items="${services}">
                                                        <option value="${service.serviceId}"
                                                                data-name="${service.serviceName}"
                                                                data-unit="${service.unit}"
                                                                data-price="${service.pricePerUnit}"
                                                                ${action == 'edit' && serviceUsage.serviceId == service.serviceId ? 'selected' : ''}>
                                                            ${service.serviceName} (${service.unit})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-3">
                                            <div class="mb-3">
                                                <label for="month" class="form-label">
                                                    <i class="bi bi-calendar-month me-1"></i>Tháng <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="month" name="month" required onchange="updatePeriod()">
                                                    <c:forEach begin="1" end="12" var="i">
                                                        <option value="${i}" 
                                                                ${(action == 'edit' ? serviceUsage.month : currentMonth) == i ? 'selected' : ''}>
                                                            Tháng ${i}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3">
                                            <div class="mb-3">
                                                <label for="year" class="form-label">
                                                    <i class="bi bi-calendar-year me-1"></i>Năm <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="year" name="year" required onchange="updatePeriod()">
                                                    <c:forEach begin="2020" end="2030" var="i">
                                                        <option value="${i}" 
                                                                ${(action == 'edit' ? serviceUsage.year : currentYear) == i ? 'selected' : ''}>
                                                            ${i}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="quantity" class="form-label">
                                                    <i class="bi bi-calculator me-1"></i>Số lượng sử dụng <span class="text-danger">*</span>
                                                </label>
                                                <div class="input-group">
                                                    <input type="number" step="0.01" min="0" class="form-control" 
                                                           id="quantity" name="quantity" 
                                                           value="${action == 'edit' ? serviceUsage.quantity : ''}"
                                                           placeholder="Nhập số lượng" required onchange="calculateTotal()">
                                                    <span class="input-group-text" id="unitDisplay">đơn vị</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Service Info Display -->
                                    <div id="serviceInfo" class="service-info p-3 mb-3" style="display: none;">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-tools me-1"></i>Dịch vụ:</strong> <span id="displayServiceName">-</span><br>
                                                <strong><i class="bi bi-calculator me-1"></i>Đơn vị:</strong> <span id="displayServiceUnit">-</span>
                                            </div>
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-cash me-1"></i>Đơn giá:</strong> <span id="displayServicePrice">-</span> VNĐ/<span id="displayPriceUnit">đơn vị</span><br>
                                                <strong><i class="bi bi-calendar-event me-1"></i>Kỳ:</strong> <span id="displayPeriod">-</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Calculation Display -->
                                    <div id="calculationBox" class="calculation-box p-3 mb-3" style="display: none;">
                                        <div class="text-center">
                                            <h6 class="text-warning mb-2"><i class="bi bi-calculator me-2"></i>Tính toán chi phí</h6>
                                            <p class="mb-1">
                                                <span id="calcQuantity">0</span> × <span id="calcPrice">0</span> VNĐ = 
                                                <strong class="fs-5 text-success" id="totalCost">0 VNĐ</strong>
                                            </p>
                                            <small class="text-muted">Số lượng × Đơn giá = Tổng tiền</small>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/admin/service-usage" class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left me-2"></i>Quay lại
                                        </a>
                                        <button type="submit" class="btn btn-custom" id="submitBtn">
                                            <i class="bi bi-check-lg me-2"></i>
                                            <c:choose>
                                                <c:when test="${action == 'edit'}">Cập nhật</c:when>
                                                <c:otherwise>Thêm mới</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Initialize form if editing
        <c:if test="${action == 'edit'}">
            document.addEventListener('DOMContentLoaded', function() {
                updateTenantInfo();
                updateServiceInfo();
                updatePeriod();
                calculateTotal();
            });
        </c:if>
        
        function updateTenantInfo() {
            const tenantSelect = document.getElementById('tenantId');
            
            if (tenantSelect.value) {
                // Update display if needed
            }
        }
        
        function updateServiceInfo() {
            const serviceSelect = document.getElementById('serviceId');
            const serviceInfo = document.getElementById('serviceInfo');
            const unitDisplay = document.getElementById('unitDisplay');
            
            if (serviceSelect.value) {
                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                const serviceName = selectedOption.getAttribute('data-name');
                const unit = selectedOption.getAttribute('data-unit');
                const price = selectedOption.getAttribute('data-price');
                
                document.getElementById('displayServiceName').textContent = serviceName;
                document.getElementById('displayServiceUnit').textContent = unit;
                document.getElementById('displayServicePrice').textContent = formatNumber(price);
                document.getElementById('displayPriceUnit').textContent = unit;
                
                unitDisplay.textContent = unit;
                serviceInfo.style.display = 'block';
                
                updatePeriod();
                calculateTotal();
            } else {
                serviceInfo.style.display = 'none';
                unitDisplay.textContent = 'đơn vị';
            }
        }
        
        function updatePeriod() {
            const monthSelect = document.getElementById('month');
            const yearSelect = document.getElementById('year');
            const periodDisplay = document.getElementById('displayPeriod');
            
            if (monthSelect.value && yearSelect.value) {
                const monthText = monthSelect.options[monthSelect.selectedIndex].text;
                periodDisplay.textContent = monthText + ' ' + yearSelect.value;
            } else {
                periodDisplay.textContent = '-';
            }
        }
        
        function calculateTotal() {
            const serviceSelect = document.getElementById('serviceId');
            const quantityInput = document.getElementById('quantity');
            const calculationBox = document.getElementById('calculationBox');
            
            if (serviceSelect.value && quantityInput.value) {
                const selectedOption = serviceSelect.options[serviceSelect.selectedIndex];
                const price = parseFloat(selectedOption.getAttribute('data-price'));
                const quantity = parseFloat(quantityInput.value);
                const total = price * quantity;
                
                document.getElementById('calcQuantity').textContent = formatNumber(quantity);
                document.getElementById('calcPrice').textContent = formatNumber(price);
                document.getElementById('totalCost').textContent = formatNumber(total) + ' VNĐ';
                
                calculationBox.style.display = 'block';
            } else {
                calculationBox.style.display = 'none';
            }
        }
        
        function formatNumber(num) {
            return parseFloat(num).toLocaleString('vi-VN');
        }
        
        // Form validation
        document.getElementById('serviceUsageForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const tenantId = document.getElementById('tenantId').value;
            const serviceId = document.getElementById('serviceId').value;
            const month = document.getElementById('month').value;
            const year = document.getElementById('year').value;
            const quantity = document.getElementById('quantity').value;
            
            if (!tenantId || !serviceId || !month || !year || !quantity) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }
            
            if (parseFloat(quantity) < 0) {
                e.preventDefault();
                alert('Số lượng sử dụng không được âm!');
                return;
            }
            
            // Disable submit button to prevent double submission
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Đang xử lý...';
        });
    </script>
</body>
</html>
