<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
                        <a href="${pageContext.request.contextPath}/admin/service-usage" class="nav-link">
                            <i class="bi bi-graph-up me-2"></i>Sử dụng DV
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/additional-costs" class="nav-link">
                            <i class="bi bi-plus-circle me-2"></i>Chi phí PS
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/bills" class="nav-link active">
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
                        <h2><i class="bi bi-plus-lg me-2"></i>${pageTitle}</h2>
                        <p class="text-muted mb-0">Tạo hóa đơn mới cho người thuê</p>
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
                
                <!-- Generate Bill Form -->
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header py-3">
                                <h5 class="mb-0"><i class="bi bi-file-earmark-plus me-2"></i>Thông tin Hóa đơn</h5>
                            </div>
                            <div class="card-body">
                                <!-- Info Box -->
                                <div class="info-box p-3 mb-4">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-info-circle fs-3 text-primary me-3"></i>
                                        <div>
                                            <h6 class="mb-1">Lưu ý khi tạo hóa đơn:</h6>
                                            <small class="text-muted">
                                                • Hóa đơn sẽ tự động tính tổng: Tiền phòng + Tiền dịch vụ + Chi phí phát sinh<br>
                                                • Đảm bảo đã nhập đầy đủ thông tin sử dụng dịch vụ và chi phí phát sinh trước khi tạo hóa đơn<br>
                                                • Mỗi người thuê chỉ có thể có 1 hóa đơn cho mỗi kỳ thanh toán
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                
                                <form action="${pageContext.request.contextPath}/admin/bills/generate/services" method="POST" id="generateBillForm">
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
                                                                data-phone="${tenant.phone}">
                                                            ${tenant.fullName} - ${tenant.roomName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-3">
                                            <div class="mb-3">
                                                <label for="month" class="form-label">
                                                    <i class="bi bi-calendar-month me-1"></i>Tháng <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="month" name="month" required>
                                                    <option value="">-- Tháng --</option>
                                                    <c:forEach begin="1" end="12" var="i">
                                                        <option value="${i}" ${i == currentMonth ? 'selected' : ''}>
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
                                                <select class="form-select" id="year" name="year" required>
                                                    <option value="">-- Năm --</option>
                                                    <c:forEach begin="2020" end="2030" var="i">
                                                        <option value="${i}" ${i == currentYear ? 'selected' : ''}>
                                                            ${i}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Tenant Info Display -->
                                    <div id="tenantInfo" class="alert alert-info" style="display: none;">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-person me-1"></i>Tên:</strong> <span id="displayTenantName">-</span>
                                            </div>
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-telephone me-1"></i>SĐT:</strong> <span id="displayTenantPhone">-</span>
                                            </div>
                                        </div>
                                        <div class="row mt-2">
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-door-open me-1"></i>Phòng:</strong> <span id="displayRoomName">-</span>
                                            </div>
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-calendar-event me-1"></i>Kỳ:</strong> 
                                                <span id="displayPeriod">-</span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between">
                                        <a href="${pageContext.request.contextPath}/admin/bills" class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left me-2"></i>Quay lại
                                        </a>
                                        <button type="submit" class="btn btn-custom" id="submitBtn">
                                            <i class="bi bi-arrow-right me-2"></i>Tiếp tục
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
        function updateTenantInfo() {
            const tenantSelect = document.getElementById('tenantId');
            const monthSelect = document.getElementById('month');
            const yearSelect = document.getElementById('year');
            const tenantInfo = document.getElementById('tenantInfo');
            
            if (tenantSelect.value) {
                const selectedOption = tenantSelect.options[tenantSelect.selectedIndex];
                document.getElementById('displayTenantName').textContent = selectedOption.getAttribute('data-name');
                document.getElementById('displayTenantPhone').textContent = selectedOption.getAttribute('data-phone');
                document.getElementById('displayRoomName').textContent = selectedOption.getAttribute('data-room');
                
                updatePeriodDisplay();
                tenantInfo.style.display = 'block';
            } else {
                tenantInfo.style.display = 'none';
            }
        }
        
        function updatePeriodDisplay() {
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
        
        // Update period display when month or year changes
        document.getElementById('month').addEventListener('change', function() {
            if (document.getElementById('tenantId').value) {
                updatePeriodDisplay();
            }
        });
        
        document.getElementById('year').addEventListener('change', function() {
            if (document.getElementById('tenantId').value) {
                updatePeriodDisplay();
            }
        });
        
        // Form validation
        document.getElementById('generateBillForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const tenantId = document.getElementById('tenantId').value;
            const month = document.getElementById('month').value;
            const year = document.getElementById('year').value;
            
            if (!tenantId || !month || !year) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin!');
                return;
            }
            
            // Disable submit button to prevent double submission
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Đang xử lý...';
        });
    </script>
</body>
</html>
