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
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .form-control:focus,
        .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .breadcrumb {
            background: white;
            border-radius: 10px;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
        }
        
        .user-card, .room-card, .service-card {
            border: 2px solid #dee2e6;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s;
            background: white;
        }
        
        .user-card:hover, .room-card:hover, .service-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
        }
        
        .user-card.selected, .room-card.selected, .service-card.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
        }
        
        .service-card .form-check-input:checked + .form-check-label {
            color: #667eea;
            font-weight: 500;
        }
        
        .user-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
        }
        
        .room-icon {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        
        .form-section {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
        }
        
        .section-title {
            color: #667eea;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .selection-grid {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .required-field {
            color: #dc3545;
        }
        
        .selected-info {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border: 2px solid #667eea;
            border-radius: 10px;
            padding: 15px;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/tenants">
                            <i class="bi bi-person-check me-2"></i>
                            Quản lý Thuê trọ
                        </a>
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/additional-costs">
                            <i class="bi bi-receipt-cutoff me-2"></i>
                            Chi phí phát sinh
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/bills">
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
                
                <!-- Add Tenant Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-house"></i> Trang chủ
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/tenants">Quản lý Thuê trọ</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Thêm thuê trọ mới</li>
                        </ol>
                    </nav>
                    
                    <!-- Success/Error Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <form method="POST" action="${pageContext.request.contextPath}/admin/tenants/add">
                        <!-- User Selection Section -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-person-plus me-2"></i>
                                Chọn Khách hàng <span class="required-field">*</span>
                            </h5>
                            
                            <div class="alert alert-info mb-3">
                                <i class="bi bi-info-circle me-2"></i>
                                <strong>Lưu ý:</strong> Chỉ hiển thị những khách hàng chưa thuê phòng nào. Một phòng có thể có tối đa 4 người thuê.
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty availableUsers}">
                                    <div class="row selection-grid">
                                        <c:forEach var="availableUser" items="${availableUsers}">
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <div class="user-card p-3" onclick="selectUser(${availableUser.userId})">
                                                    <div class="d-flex align-items-center">
                                                        <div class="user-avatar me-3">
                                                            ${availableUser.fullName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div class="flex-grow-1">
                                                            <strong>${availableUser.fullName}</strong>
                                                            <br>
                                                            <small class="text-muted">
                                                                <i class="bi bi-envelope me-1"></i>
                                                                ${availableUser.email}
                                                            </small>
                                                            <c:if test="${not empty availableUser.phone}">
                                                                <br>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-telephone me-1"></i>
                                                                    ${availableUser.phone}
                                                                </small>
                                                            </c:if>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input user-radio" 
                                                                   type="radio" 
                                                                   name="userId" 
                                                                   value="${availableUser.userId}"
                                                                   ${selectedUserId == availableUser.userId ? 'checked' : ''}
                                                                   required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <!-- Selected User Info -->
                                    <div id="selectedUserInfo" class="selected-info mt-3" style="display: none;">
                                        <h6><i class="bi bi-person-check me-2"></i>Khách hàng đã chọn:</h6>
                                        <div id="selectedUserDetails"></div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Không có khách hàng nào có sẵn để thuê phòng.
                                        <a href="${pageContext.request.contextPath}/admin/tenants" class="alert-link">
                                            Quay lại danh sách thuê trọ
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Room Selection Section -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-door-open me-2"></i>
                                Chọn Phòng trọ <span class="required-field">*</span>
                            </h5>
                            
                            <div class="alert alert-success mb-3">
                                <i class="bi bi-people me-2"></i>
                                <strong>Thông tin:</strong> Chỉ hiển thị các phòng còn chỗ trống (dưới 4 người). Số trong ngoặc cho biết số người hiện tại/tối đa.
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty availableRooms}">
                                    <div class="row selection-grid">
                                        <c:forEach var="room" items="${availableRooms}">
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <div class="room-card p-3" onclick="selectRoom(${room.roomId})">
                                                    <div class="d-flex align-items-center">
                                                        <div class="room-icon me-3">
                                                            <i class="bi bi-door-open"></i>
                                                        </div>
                                                        <div class="flex-grow-1">
                                                            <strong>${room.roomName}</strong>
                                                            <br>
                                                            <span class="text-success fw-bold">
                                                                <fmt:formatNumber value="${room.price}" 
                                                                                type="currency" 
                                                                                currencySymbol="₫" 
                                                                                groupingUsed="true"/>
                                                            </span>
                                                            <c:if test="${not empty room.description}">
                                                                <br>
                                                                <small class="text-muted">${room.description}</small>
                                                            </c:if>
                                                        </div>
                                                        <div class="form-check">
                                                            <input class="form-check-input room-radio" 
                                                                   type="radio" 
                                                                   name="roomId" 
                                                                   value="${room.roomId}"
                                                                   ${selectedRoomId == room.roomId ? 'checked' : ''}
                                                                   required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <!-- Selected Room Info -->
                                    <div id="selectedRoomInfo" class="selected-info mt-3" style="display: none;">
                                        <h6><i class="bi bi-door-open me-2"></i>Phòng trọ đã chọn:</h6>
                                        <div id="selectedRoomDetails"></div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Không có phòng trọ nào có sẵn để thuê.
                                        <a href="${pageContext.request.contextPath}/admin/rooms/add" class="alert-link">
                                            Thêm phòng trọ mới
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Service Selection Section -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-tools me-2"></i>
                                Chọn Dịch vụ
                            </h5>
                            
                            <c:choose>
                                <c:when test="${not empty availableServices}">
                    <p class="text-muted mb-3">
                        Chọn các dịch vụ mà khách hàng sẽ sử dụng. Đối với <strong>điện và nước</strong>, bạn cần nhập chỉ số công tơ ban đầu. Các dịch vụ khác (Internet, giữ xe, v.v.) sẽ được tính theo gói cố định.
                    </p>
                                    <div class="row">
                                        <c:forEach var="service" items="${availableServices}">
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <div class="card h-100 service-card">
                                                    <div class="card-body">
                                                        <div class="form-check">
                                                            <input class="form-check-input service-checkbox" 
                                                                   type="checkbox" 
                                                                   name="serviceIds" 
                                                                   value="${service.serviceId}"
                                                                   id="service_${service.serviceId}"
                                                                   data-service-name="${service.serviceName}"
                                                                   data-service-unit="${service.unit}">
                                                            <label class="form-check-label w-100" for="service_${service.serviceId}">
                                                                <div class="d-flex justify-content-between align-items-start">
                                                                    <div>
                                                                        <h6 class="mb-1">${service.serviceName}</h6>
                                                                        <small class="text-muted">
                                                                            <fmt:formatNumber value="${service.pricePerUnit}" 
                                                                                            type="currency" 
                                                                                            currencySymbol="₫" 
                                                                                            groupingUsed="true"/> / ${service.unit}
                                                                        </small>
                                                                    </div>
                                                                    <i class="bi bi-tools text-primary"></i>
                                                                </div>
                                                            </label>
                                                            
                                                            <!-- Meter Reading Input (only for electricity and water) -->
                                                            <c:set var="serviceLower" value="${service.serviceName.toLowerCase()}" />
                                                            <c:if test="${serviceLower.contains('điện') || serviceLower.contains('nước') || serviceLower.contains('electric') || serviceLower.contains('water')}">
                                                                <div class="meter-reading-input mt-3" id="meter_${service.serviceId}" style="display: none;">
                                                                    <label class="form-label small">
                                                                        <i class="bi bi-speedometer2 me-1"></i>
                                                                        Chỉ số công tơ ban đầu (${service.unit}):
                                                                    </label>
                                                                    <input type="number" 
                                                                           class="form-control form-control-sm" 
                                                                           name="initialReadings" 
                                                                           step="0.01" 
                                                                           min="0" 
                                                                           placeholder="Nhập chỉ số hiện tại"
                                                                           data-has-meter="true">
                                                                    <div class="form-text small">
                                                                        Nhập chỉ số công tơ hiện tại của ${service.serviceName.toLowerCase()}
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <!-- Selected Services Info -->
                                    <div id="selectedServicesInfo" class="selected-info mt-3" style="display: none;">
                                        <h6><i class="bi bi-check2-square me-2"></i>Dịch vụ đã chọn:</h6>
                                        <div id="selectedServicesList"></div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info">
                                        <i class="bi bi-info-circle me-2"></i>
                                        Không có dịch vụ nào được cài đặt trong hệ thống.
                                        <a href="${pageContext.request.contextPath}/admin/services/add" class="alert-link">
                                            Thêm dịch vụ mới
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Rental Details Section -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-calendar-check me-2"></i>
                                Thông tin thuê trọ
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <label for="startDate" class="form-label">
                                        Ngày bắt đầu thuê <span class="required-field">*</span>
                                    </label>
                                    <input type="date" 
                                           class="form-control" 
                                           id="startDate" 
                                           name="startDate" 
                                           value="${startDate != null ? startDate : ''}" 
                                           required>
                                    <div class="form-text">Ngày khách hàng bắt đầu thuê phòng</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Trạng thái</label>
                                    <input type="text" class="form-control-plaintext" value="Đang thuê" readonly>
                                    <div class="form-text">Khách hàng sẽ được đánh dấu là đang thuê phòng</div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="form-section">
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-2"></i>
                                    Thêm thuê trọ
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/tenants" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>
                                    Quay lại
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // User selection handler
        function selectUser(userId) {
            // Clear previous selection
            document.querySelectorAll('.user-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Select current user
            const selectedCard = event.currentTarget;
            selectedCard.classList.add('selected');
            
            // Check the radio button
            const radio = selectedCard.querySelector('.user-radio');
            radio.checked = true;
            
            // Show selected user info
            showSelectedUserInfo(userId, selectedCard);
        }
        
        // Room selection handler
        function selectRoom(roomId) {
            // Clear previous selection
            document.querySelectorAll('.room-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Select current room
            const selectedCard = event.currentTarget;
            selectedCard.classList.add('selected');
            
            // Check the radio button
            const radio = selectedCard.querySelector('.room-radio');
            radio.checked = true;
            
            // Show selected room info
            showSelectedRoomInfo(roomId, selectedCard);
        }
        
        function showSelectedUserInfo(userId, card) {
            const userName = card.querySelector('strong').textContent;
            const userEmail = card.querySelector('.bi-envelope').parentElement.textContent.trim();
            const phoneElement = card.querySelector('.bi-telephone');
            const userPhone = phoneElement ? phoneElement.parentElement.textContent.trim() : '';
            
            const infoDiv = document.getElementById('selectedUserInfo');
            const detailsDiv = document.getElementById('selectedUserDetails');
            
            let phoneHtml = '';
            if (userPhone) {
                phoneHtml = '<br><small class="text-muted">' + userPhone + '</small>';
            }
            
            detailsDiv.innerHTML = 
                '<div class="d-flex align-items-center">' +
                    '<div class="user-avatar me-3">' + userName.substring(0, 1).toUpperCase() + '</div>' +
                    '<div>' +
                        '<strong>' + userName + '</strong><br>' +
                        '<small class="text-muted">' + userEmail + '</small>' +
                        phoneHtml +
                    '</div>' +
                '</div>';
            
            infoDiv.style.display = 'block';
        }
        
        function showSelectedRoomInfo(roomId, card) {
            const roomName = card.querySelector('strong').textContent;
            const roomPrice = card.querySelector('.text-success').textContent;
            const descElement = card.querySelector('small.text-muted');
            const roomDesc = descElement ? descElement.textContent : '';
            
            const infoDiv = document.getElementById('selectedRoomInfo');
            const detailsDiv = document.getElementById('selectedRoomDetails');
            
            let descHtml = '';
            if (roomDesc) {
                descHtml = '<br><small class="text-muted">' + roomDesc + '</small>';
            }
            
            detailsDiv.innerHTML = 
                '<div class="d-flex align-items-center">' +
                    '<div class="room-icon me-3">' +
                        '<i class="bi bi-door-open"></i>' +
                    '</div>' +
                    '<div>' +
                        '<strong>' + roomName + '</strong><br>' +
                        '<span class="text-success fw-bold">' + roomPrice + '</span>' +
                        descHtml +
                    '</div>' +
                '</div>';
            
            infoDiv.style.display = 'block';
        }
        
        // Initialize page - show selected items if any
        document.addEventListener('DOMContentLoaded', function() {
            // Set today's date as default start date if not set
            const startDateInput = document.getElementById('startDate');
            if (!startDateInput.value) {
                const today = new Date().toISOString().split('T')[0];
                startDateInput.value = today;
            }
            
            // Show selected user info if pre-selected
            const selectedUserRadio = document.querySelector('.user-radio:checked');
            if (selectedUserRadio) {
                const userCard = selectedUserRadio.closest('.user-card');
                userCard.classList.add('selected');
                showSelectedUserInfo(selectedUserRadio.value, userCard);
            }
            
            // Show selected room info if pre-selected
            const selectedRoomRadio = document.querySelector('.room-radio:checked');
            if (selectedRoomRadio) {
                const roomCard = selectedRoomRadio.closest('.room-card');
                roomCard.classList.add('selected');
                showSelectedRoomInfo(selectedRoomRadio.value, roomCard);
            }
            
            // Service selection handlers
            document.querySelectorAll('.service-checkbox').forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const serviceCard = this.closest('.service-card');
                    const meterInput = document.getElementById('meter_' + this.value);
                    
                    if (this.checked) {
                        serviceCard.classList.add('selected');
                        // Only show meter input if it exists (for electricity and water)
                        if (meterInput) {
                            const readingInput = meterInput.querySelector('input[name="initialReadings"]');
                            meterInput.style.display = 'block';
                            if (readingInput) {
                                readingInput.required = true;
                            }
                        }
                    } else {
                        serviceCard.classList.remove('selected');
                        // Only hide meter input if it exists
                        if (meterInput) {
                            const readingInput = meterInput.querySelector('input[name="initialReadings"]');
                            meterInput.style.display = 'none';
                            if (readingInput) {
                                readingInput.required = false;
                                readingInput.value = '';
                            }
                        }
                    }
                    updateSelectedServices();
                });
            });
            
            // Add event listeners to meter reading inputs to update display
            document.querySelectorAll('input[name="initialReadings"]').forEach(input => {
                input.addEventListener('input', function() {
                    updateSelectedServices();
                });
            });
            
            // Add click listeners to cards for better UX
            document.querySelectorAll('.user-card').forEach(card => {
                const radio = card.querySelector('.user-radio');
                card.addEventListener('click', function(e) {
                    if (e.target.type !== 'radio') {
                        selectUser(radio.value);
                    }
                });
            });
            
            document.querySelectorAll('.room-card').forEach(card => {
                const radio = card.querySelector('.room-radio');
                card.addEventListener('click', function(e) {
                    if (e.target.type !== 'radio') {
                        selectRoom(radio.value);
                    }
                });
            });
            
            document.querySelectorAll('.service-card').forEach(card => {
                card.addEventListener('click', function(e) {
                    const checkbox = this.querySelector('.service-checkbox');
                    // Don't toggle if clicking on meter reading input or its label
                    if (e.target.type !== 'checkbox' && e.target.tagName !== 'LABEL' && 
                        e.target.type !== 'number' && !e.target.closest('.meter-reading-input')) {
                        checkbox.checked = !checkbox.checked;
                        checkbox.dispatchEvent(new Event('change'));
                    }
                });
            });
        });
        
        // Function to update selected services display
        function updateSelectedServices() {
            const selectedCheckboxes = document.querySelectorAll('.service-checkbox:checked');
            const infoDiv = document.getElementById('selectedServicesInfo');
            const listDiv = document.getElementById('selectedServicesList');
            
            if (selectedCheckboxes.length > 0) {
                let servicesHtml = '<div class="row">';
                selectedCheckboxes.forEach(checkbox => {
                    const label = checkbox.nextElementSibling;
                    const serviceName = label.querySelector('h6').textContent;
                    const servicePrice = label.querySelector('small').textContent;
                    const meterInput = document.getElementById('meter_' + checkbox.value);
                    
                    let readingHtml = '';
                    // Only show meter reading info if meter input exists (for electricity and water)
                    if (meterInput) {
                        const readingInput = meterInput.querySelector('input[name="initialReadings"]');
                        const readingValue = readingInput ? readingInput.value : '';
                        
                        if (readingValue) {
                            readingHtml = '<br><small class="text-info"><i class="bi bi-speedometer2 me-1"></i>Chỉ số: ' + readingValue + ' ' + checkbox.dataset.serviceUnit + '</small>';
                        } else {
                            readingHtml = '<br><small class="text-warning"><i class="bi bi-exclamation-triangle me-1"></i>Chưa nhập chỉ số</small>';
                        }
                    } else {
                        // For services without meter (Internet, parking, etc.)
                        readingHtml = '<br><small class="text-muted"><i class="bi bi-info-circle me-1"></i>Dịch vụ cố định</small>';
                    }
                    
                    servicesHtml += 
                        '<div class="col-md-6 mb-2">' +
                            '<div class="d-flex align-items-center">' +
                                '<i class="bi bi-check-circle-fill text-success me-2"></i>' +
                                '<div>' +
                                    '<strong>' + serviceName + '</strong><br>' +
                                    '<small class="text-muted">' + servicePrice + '</small>' +
                                    readingHtml +
                                '</div>' +
                            '</div>' +
                        '</div>';
                });
                servicesHtml += '</div>';
                
                listDiv.innerHTML = servicesHtml;
                infoDiv.style.display = 'block';
            } else {
                infoDiv.style.display = 'none';
            }
        }
    </script>
</body>
</html>
