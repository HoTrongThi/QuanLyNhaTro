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
            color: white;
        }
        
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            margin: 2px 0;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .navbar {
            background: white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
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
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="p-3">
                    <h4 class="text-center mb-4">
                        <i class="bi bi-building me-2"></i>
                        Admin Panel
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-person-gear fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">Quản trị viên</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people me-2"></i>
                            Quản lý Người dùng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/rooms">
                            <i class="bi bi-door-open me-2"></i>
                            Quản lý Phòng trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/services">
                            <i class="bi bi-tools me-2"></i>
                            Quản lý Dịch vụ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/tenants">
                            <i class="bi bi-person-check me-2"></i>
                            Quản lý Thuê trọ
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/additional-costs">
                            <i class="bi bi-receipt-cutoff me-2"></i>
                            Chi phí phát sinh
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Quản lý Hóa đơn
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">
                            <i class="bi bi-chat-dots me-2"></i>
                            Tin nhắn
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                            <i class="bi bi-graph-up me-2"></i>
                            Báo cáo & Thống kê
                        </a>
                        <hr class="text-light">
                        <a class="nav-link text-warning" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i>
                            Đăng xuất
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Top Navigation -->
                <nav class="navbar navbar-expand-lg navbar-light">
                    <div class="container-fluid">
                        <h5 class="navbar-brand mb-0">${pageTitle}</h5>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle me-1"></i>
                                    ${user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Generate Bill Content -->
                <div class="p-4">
                
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
                                                • Mỗi phòng chỉ có thể có 1 hóa đơn cho mỗi kỳ thanh toán
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                
                                <form action="${pageContext.request.contextPath}/admin/bills/generate/services" method="POST" id="generateBillForm">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="roomId" class="form-label">
                                                    <i class="bi bi-door-open me-1"></i>Phòng <span class="text-danger">*</span>
                                                </label>
                                                <select class="form-select" id="roomId" name="roomId" required onchange="updateRoomInfo()">
                                                    <option value="">-- Chọn phòng --</option>
                                                    <c:forEach var="room" items="${rooms}">
                                                        <option value="${room.roomId}" 
                                                                data-name="${room.roomName}" 
                                                                data-price="${room.price}"
                                                                data-status="${room.status}">
                                                            ${room.roomName} - ${room.price} VNĐ
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
                                    
                                    <!-- Room Info Display -->
                                    <div id="roomInfo" class="alert alert-info" style="display: none;">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-door-open me-1"></i>Phòng:</strong> <span id="displayRoomName">-</span>
                                            </div>
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-cash me-1"></i>Giá phòng:</strong> <span id="displayRoomPrice">-</span>
                                            </div>
                                        </div>
                                        <div class="row mt-2">
                                            <div class="col-md-6">
                                                <strong><i class="bi bi-info-circle me-1"></i>Trạng thái:</strong> <span id="displayRoomStatus">-</span>
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
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateRoomInfo() {
            const roomSelect = document.getElementById('roomId');
            const monthSelect = document.getElementById('month');
            const yearSelect = document.getElementById('year');
            const roomInfo = document.getElementById('roomInfo');
            
            if (roomSelect.value) {
                const selectedOption = roomSelect.options[roomSelect.selectedIndex];
                document.getElementById('displayRoomName').textContent = selectedOption.getAttribute('data-name');
                document.getElementById('displayRoomPrice').textContent = selectedOption.getAttribute('data-price') + ' VNĐ';
                
                const status = selectedOption.getAttribute('data-status');
                let statusText = status;
                if (status === 'OCCUPIED') statusText = 'Đang thuê';
                else if (status === 'AVAILABLE') statusText = 'Trống';
                else if (status === 'MAINTENANCE') statusText = 'Bảo trì';
                document.getElementById('displayRoomStatus').textContent = statusText;
                
                updatePeriodDisplay();
                roomInfo.style.display = 'block';
            } else {
                roomInfo.style.display = 'none';
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
            if (document.getElementById('roomId').value) {
                updatePeriodDisplay();
            }
        });
        
        document.getElementById('year').addEventListener('change', function() {
            if (document.getElementById('roomId').value) {
                updatePeriodDisplay();
            }
        });
        
        // Form validation
        document.getElementById('generateBillForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const roomId = document.getElementById('roomId').value;
            const month = document.getElementById('month').value;
            const year = document.getElementById('year').value;
            
            if (!roomId || !month || !year) {
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
