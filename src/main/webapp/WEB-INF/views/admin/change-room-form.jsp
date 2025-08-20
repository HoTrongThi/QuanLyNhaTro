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
        
        .breadcrumb {
            background: white;
            border-radius: 10px;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
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
        
        .current-room {
            background: linear-gradient(135deg, rgba(108, 117, 125, 0.1) 0%, rgba(108, 117, 125, 0.05) 100%);
            border: 2px solid #6c757d;
            border-radius: 15px;
            padding: 1.5rem;
        }
        
        .room-card {
            border: 2px solid #dee2e6;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s;
            background: white;
        }
        
        .room-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.2);
        }
        
        .room-card.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
        }
        
        .room-icon {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        
        .current-room-icon {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        
        .tenant-info {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border: 2px solid #667eea;
            border-radius: 15px;
            padding: 1.5rem;
        }
        
        .tenant-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .selection-grid {
            max-height: 500px;
            overflow-y: auto;
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
                
                <!-- Change Room Content -->
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
                            <li class="breadcrumb-item active" aria-current="page">Đổi phòng</li>
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
                    
                    <form method="POST" action="${pageContext.request.contextPath}/admin/tenants/change-room/${tenant.tenantId}">
                        <!-- Tenant Information -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-person-check me-2"></i>
                                Thông tin khách thuê
                            </h5>
                            
                            <div class="tenant-info">
                                <div class="d-flex align-items-center">
                                    <div class="tenant-avatar me-3">
                                        ${tenant.fullName.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div>
                                        <h6 class="mb-1">${tenant.fullName}</h6>
                                        <small class="text-muted">
                                            <i class="bi bi-envelope me-1"></i>
                                            ${tenant.email}
                                        </small>
                                        <c:if test="${not empty tenant.phone}">
                                            <br>
                                            <small class="text-muted">
                                                <i class="bi bi-telephone me-1"></i>
                                                ${tenant.phone}
                                            </small>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Current Room -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-house-door me-2"></i>
                                Phòng hiện tại
                            </h5>
                            
                            <div class="current-room">
                                <div class="d-flex align-items-center">
                                    <div class="current-room-icon me-3">
                                        <i class="bi bi-door-closed"></i>
                                    </div>
                                    <div class="flex-grow-1">
                                        <h6 class="mb-1">${tenant.roomName}</h6>
                                        <div class="d-flex align-items-center gap-3">
                                            <span class="text-success fw-bold">
                                                <fmt:formatNumber value="${tenant.roomPrice}" 
                                                                type="currency" 
                                                                currencySymbol="₫" 
                                                                groupingUsed="true"/>
                                            </span>
                                            <small class="text-muted">
                                                Thuê từ: <fmt:formatDate value="${tenant.startDate}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Available Rooms Selection -->
                        <div class="form-section">
                            <h5 class="section-title">
                                <i class="bi bi-door-open me-2"></i>
                                Chọn phòng mới <span class="text-danger">*</span>
                            </h5>
                            
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
                                                                   name="newRoomId" 
                                                                   value="${room.roomId}"
                                                                   required>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <!-- Price Comparison -->
                                    <div id="priceComparison" class="mt-3" style="display: none;">
                                        <div class="alert alert-info">
                                            <h6><i class="bi bi-calculator me-2"></i>So sánh giá phòng:</h6>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="text-muted">Phòng hiện tại:</div>
                                                    <div class="fw-bold">
                                                        <fmt:formatNumber value="${tenant.roomPrice}" 
                                                                        type="currency" 
                                                                        currencySymbol="₫" 
                                                                        groupingUsed="true"/>
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="text-muted">Phòng mới:</div>
                                                    <div class="fw-bold" id="newRoomPrice">-</div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="text-muted">Chênh lệch:</div>
                                                    <div class="fw-bold" id="priceDifference">-</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Hiện tại không có phòng trọ nào có sẵn để đổi.
                                        <a href="${pageContext.request.contextPath}/admin/rooms" class="alert-link">
                                            Quản lý phòng trọ
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="form-section">
                            <div class="d-flex gap-2 justify-content-center">
                                <c:if test="${not empty availableRooms}">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-arrow-left-right me-2"></i>
                                        Đổi phòng
                                    </button>
                                </c:if>
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
        const currentRoomPrice = ${tenant.roomPrice};
        
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
            
            // Update price comparison
            updatePriceComparison(selectedCard);
        }
        
        function updatePriceComparison(selectedCard) {
            const priceText = selectedCard.querySelector('.text-success').textContent;
            const priceValue = parseFloat(priceText.replace(/[^\d]/g, ''));
            
            const newRoomPriceElement = document.getElementById('newRoomPrice');
            const priceDifferenceElement = document.getElementById('priceDifference');
            const comparisonDiv = document.getElementById('priceComparison');
            
            newRoomPriceElement.textContent = priceText;
            
            const difference = priceValue - currentRoomPrice;
            const differenceFormatted = new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                currencyDisplay: 'symbol'
            }).format(Math.abs(difference)).replace('VND', '₫');
            
            if (difference > 0) {
                priceDifferenceElement.textContent = '+' + differenceFormatted;
                priceDifferenceElement.className = 'fw-bold text-danger';
            } else if (difference < 0) {
                priceDifferenceElement.textContent = '-' + differenceFormatted;
                priceDifferenceElement.className = 'fw-bold text-success';
            } else {
                priceDifferenceElement.textContent = '0₫';
                priceDifferenceElement.className = 'fw-bold text-muted';
            }
            
            comparisonDiv.style.display = 'block';
        }
        
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Add click listeners to room cards
            document.querySelectorAll('.room-card').forEach(card => {
                const radio = card.querySelector('.room-radio');
                card.addEventListener('click', function(e) {
                    if (e.target.type !== 'radio') {
                        selectRoom(radio.value);
                    }
                });
            });
            
            // Form validation
            const form = document.querySelector('form');
            form.addEventListener('submit', function(e) {
                const selectedRoom = document.querySelector('.room-radio:checked');
                if (!selectedRoom) {
                    e.preventDefault();
                    alert('Vui lòng chọn phòng mới!');
                    return;
                }
                
                // Confirm before submitting
                const roomName = selectedRoom.closest('.room-card').querySelector('strong').textContent;
                if (!confirm(`Bạn có chắc chắn muốn đổi phòng từ "${tenant.roomName}" sang "${roomName}"?`)) {
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>
