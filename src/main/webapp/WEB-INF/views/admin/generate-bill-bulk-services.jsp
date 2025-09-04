<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
        
        .room-card {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            margin-bottom: 25px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }
        
        .room-card:hover {
            border-color: #667eea;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.12);
            transform: translateY(-2px);
        }
        
        .room-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 20px;
        }
        
        .service-item {
            background: #ffffff;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 8px;
            border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }
        
        .service-item:hover {
            border-color: #667eea;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
        }
        
        .btn-secondary {
            border-radius: 10px;
        }
        
        .tenant-list {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 10px;
            margin-top: 10px;
        }
        
        .additional-costs {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 10px;
            margin-top: 10px;
        }
        
        .period-info {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.2);
        }
        
        .service-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 12px;
        }
        
        .form-control {
            border-radius: 6px;
            border: 1px solid #dee2e6;
            font-size: 0.9rem;
        }
        
        .badge {
            font-size: 0.75rem;
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
                
                <!-- Bulk Service Usage Content -->
                <div class="p-4">
                    <!-- Period Info -->
                    <div class="period-info">
                        <h4><i class="bi bi-calendar-event me-2"></i>Kỳ thanh toán: <fmt:formatNumber value="${month}" minIntegerDigits="2"/>/${year}</h4>
                        <p class="mb-0">Tạo hóa đơn cho ${fn:length(occupiedRooms)} phòng đang có người thuê</p>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/bills/generate/bulk-final" method="post" id="bulkBillForm">
                        <input type="hidden" name="month" value="${month}">
                        <input type="hidden" name="year" value="${year}">

                        <!-- Room Cards -->
                        <c:forEach var="roomInfo" items="${occupiedRooms}" varStatus="roomStatus">
                            <div class="room-card">
                                <div class="room-header">
                                    <div class="row align-items-center">
                                        <div class="col-md-4">
                                            <h6 class="mb-1">
                                                <i class="bi bi-door-open me-2"></i>
                                                ${roomInfo.roomName}
                                            </h6>
                                            <small class="opacity-90">
                                                Giá gốc: <fmt:formatNumber value="${roomInfo.fullRoomPrice}" pattern="#,##0"/> VNĐ
                                                <c:if test="${roomInfo.roomPrice != roomInfo.fullRoomPrice}">
                                                    <br><span class="text-warning">
                                                        <i class="bi bi-calendar-check me-1"></i>
                                                        Tính theo tỷ lệ: <fmt:formatNumber value="${roomInfo.roomPrice}" pattern="#,##0"/> VNĐ
                                                    </span>
                                                </c:if>
                                            </small>
                                        </div>
                                        <div class="col-md-8">
                                            <div class="d-flex align-items-center">
                                                <small class="me-2"><i class="bi bi-people me-1"></i>Người thuê:</small>
                                                <div>
                                                    <c:forEach var="tenant" items="${roomInfo.tenants}" varStatus="tenantStatus">
                                                        <span class="badge bg-light bg-opacity-25 text-white me-1 small">${tenant.fullName}</span>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card-body">
                                    <!-- Hidden room ID -->
                                    <input type="hidden" name="roomIds" value="${roomInfo.roomId}">
                                    
                                    <!-- Services -->
                                    <c:choose>
                                        <c:when test="${not empty roomInfo.services}">
                                            <h6 class="mb-3">
                                                <i class="bi bi-tools me-2"></i>
                                                Dịch vụ sử dụng
                                            </h6>
                                            
                                            <div class="service-grid">
                                                <c:forEach var="service" items="${roomInfo.services}" varStatus="serviceStatus">
                                                        <!-- Check if service is free -->
                                                        <fmt:formatNumber var="priceFormatted" value="${service.pricePerUnit}" pattern="0" />
                                                        <c:set var="isFreeService" value="${priceFormatted == '0'}" />
                                                        
                                                        <div class="service-item">
                                                            <h6 class="mb-2">
                                                                <c:choose>
                                                                    <c:when test="${isFreeService}">
                                                                        <i class="bi bi-check-circle-fill text-success me-1"></i>
                                                                    </c:when>
                                                                    <c:when test="${service.unit == 'kWh'}">
                                                                        <i class="bi bi-lightning-charge text-warning me-1"></i>
                                                                    </c:when>
                                                                    <c:when test="${service.unit == 'm³'}">
                                                                        <i class="bi bi-droplet-fill text-primary me-1"></i>
                                                                    </c:when>
                                                                    <c:when test="${service.unit == 'người'}">
                                                                        <i class="bi bi-people-fill text-info me-1"></i>
                                                                    </c:when>
                                                                    <c:when test="${service.unit == 'phòng'}">
                                                                        <i class="bi bi-house-fill text-secondary me-1"></i>
                                                                    </c:when>
                                                                    <c:when test="${service.unit == 'tháng'}">
                                                                        <i class="bi bi-calendar-month text-primary me-1"></i>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="bi bi-gear-fill text-dark me-1"></i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                ${service.serviceName}
                                                            </h6>
                                                            
                                                            <div class="mb-2">
                                                                <small class="text-muted">
                                                                    Loại: <strong>
                                                                        <c:choose>
                                                                            <c:when test="${isFreeService}">Miễn phí</c:when>
                                                                            <c:when test="${service.unit == 'kWh' || service.unit == 'm³'}">Theo chỉ số</c:when>
                                                                            <c:when test="${service.unit == 'người'}">Theo đầu người</c:when>
                                                                            <c:when test="${service.unit == 'phòng'}">Theo phòng</c:when>
                                                                            <c:when test="${service.unit == 'tháng'}">Theo tháng</c:when>
                                                                            <c:otherwise>Theo số lượng</c:otherwise>
                                                                        </c:choose>
                                                                    </strong>
                                                                </small>
                                                                <c:choose>
                                                                    <c:when test="${isFreeService}">
                                                                        <br>
                                                                        <small class="text-success">
                                                                            <i class="bi bi-check-circle me-1"></i>
                                                                            <strong>Miễn phí</strong>
                                                                        </small>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <br>
                                                                        <small class="text-muted">
                                                                            Đơn giá: <strong>
                                                                                <fmt:formatNumber value="${service.pricePerUnit}" pattern="#,##0"/> VNĐ
                                                                                <c:if test="${not empty service.unit && service.unit != ''}">
                                                                                    /${service.unit}
                                                                                </c:if>
                                                                            </strong>
                                                                        </small>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            
                                                            <c:choose>
                                                                <c:when test="${isFreeService}">
                                                                    <div class="text-success">
                                                                        <i class="bi bi-check-circle me-1"></i>
                                                                        Miễn phí - Không cần nhập
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${service.unit == 'người'}">
                                                                    <!-- Per-person service - auto calculate based on tenant count -->
                                                                    <div class="text-info">
                                                                        <i class="bi bi-people me-1"></i>
                                                                        Tự động tính theo số người thuê
                                                                    </div>
                                                                    <div class="mt-2">
                                                                        <small class="text-muted">
                                                                            Số người hiện tại: <strong class="text-primary">${fn:length(roomInfo.tenants)} người</strong>
                                                                        </small>
                                                                        <br>
                                                                        <small class="text-muted">
                                                                            Công thức: <fmt:formatNumber value="${service.pricePerUnit}" pattern="#,##0"/> VNĐ × ${fn:length(roomInfo.tenants)} người
                                                                        </small>
                                                                    </div>
                                                                    <!-- Hidden input with auto-calculated quantity -->
                                                                    <input type="hidden" name="serviceIds_${roomInfo.roomId}" value="${service.serviceId}">
                                                                    <input type="hidden" name="quantity_${roomInfo.roomId}_${service.serviceId}" value="${fn:length(roomInfo.tenants)}">
                                                                    
                                                                    <!-- Show calculated cost -->
                                                                    <div class="text-end mt-2">
                                                                        <small class="text-muted">Thành tiền:</small>
                                                                        <div class="service-cost h6 text-primary" id="cost-${roomInfo.roomId}-${service.serviceId}">
                                                                            <fmt:formatNumber value="${service.pricePerUnit * fn:length(roomInfo.tenants)}" pattern="#,##0"/> VNĐ
                                                                        </div>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${service.unit == 'phòng'}">
                                                                    <!-- Per-room service - auto calculate for 1 room -->
                                                                    <div class="text-info">
                                                                        <i class="bi bi-house me-1"></i>
                                                                        Tự động tính theo phòng
                                                                    </div>
                                                                    <div class="mt-2">
                                                                        <small class="text-muted">
                                                                            Số phòng: <strong class="text-primary">1 phòng</strong>
                                                                        </small>
                                                                        <br>
                                                                        <small class="text-muted">
                                                                            Công thức: <fmt:formatNumber value="${service.pricePerUnit}" pattern="#,##0"/> VNĐ × 1 phòng
                                                                        </small>
                                                                    </div>
                                                                    <!-- Hidden input with auto-calculated quantity -->
                                                                    <input type="hidden" name="serviceIds_${roomInfo.roomId}" value="${service.serviceId}">
                                                                    <input type="hidden" name="quantity_${roomInfo.roomId}_${service.serviceId}" value="1">
                                                                    
                                                                    <!-- Show calculated cost -->
                                                                    <div class="text-end mt-2">
                                                                        <small class="text-muted">Thành tiền:</small>
                                                                        <div class="service-cost h6 text-primary" id="cost-${roomInfo.roomId}-${service.serviceId}">
                                                                            <fmt:formatNumber value="${service.pricePerUnit * 1}" pattern="#,##0"/> VNĐ
                                                                        </div>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${service.unit == 'tháng'}">
                                                                    <!-- Per-month service - auto calculate for 1 month -->
                                                                    <div class="text-info">
                                                                        <i class="bi bi-calendar-month me-1"></i>
                                                                        Tự động tính theo tháng
                                                                    </div>
                                                                    <div class="mt-2">
                                                                        <small class="text-muted">
                                                                            Số tháng: <strong class="text-primary">1 tháng</strong>
                                                                        </small>
                                                                        <br>
                                                                        <small class="text-muted">
                                                                            Công thức: <fmt:formatNumber value="${service.pricePerUnit}" pattern="#,##0"/> VNĐ × 1 tháng
                                                                        </small>
                                                                    </div>
                                                                    <!-- Hidden input with auto-calculated quantity -->
                                                                    <input type="hidden" name="serviceIds_${roomInfo.roomId}" value="${service.serviceId}">
                                                                    <input type="hidden" name="quantity_${roomInfo.roomId}_${service.serviceId}" value="1">
                                                                    
                                                                    <!-- Show calculated cost -->
                                                                    <div class="text-end mt-2">
                                                                        <small class="text-muted">Thành tiền:</small>
                                                                        <div class="service-cost h6 text-primary" id="cost-${roomInfo.roomId}-${service.serviceId}">
                                                                            <fmt:formatNumber value="${service.pricePerUnit * 1}" pattern="#,##0"/> VNĐ
                                                                        </div>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <!-- Hidden service ID -->
                                                                    <input type="hidden" name="serviceIds_${roomInfo.roomId}" value="${service.serviceId}">
                                                                    
                                                                    <c:choose>
                                                                        <c:when test="${service.unit == 'kWh' || service.unit == 'm³'}">
                                                                            <!-- Meter reading service -->
                                                                            <div class="text-info">
                                                                                <i class="bi bi-speedometer me-1"></i>
                                                                                Nhập chỉ số công tơ hiện tại
                                                                            </div>
                                                                            
                                                                            <!-- Display previous reading -->
                                                                            <div class="mt-2 mb-3">
                                                                                <small class="text-muted">
                                                                                    <i class="bi bi-speedometer2 me-1"></i>
                                                                                    Chỉ số kỳ trước: 
                                                                                    <c:choose>
                                                                                        <c:when test="${roomInfo.previousReadings[service.serviceId] != null}">
                                                                                            <strong class="text-primary">${roomInfo.previousReadings[service.serviceId].reading} ${service.unit}</strong>
                                                                                            <c:choose>
                                                                                                <c:when test="${roomInfo.previousReadings[service.serviceId].month != null && roomInfo.previousReadings[service.serviceId].year != null && roomInfo.previousReadings[service.serviceId].month > 0 && roomInfo.previousReadings[service.serviceId].year > 0}">
                                                                                                    <small class="text-success">(Kỳ ${roomInfo.previousReadings[service.serviceId].month}/${roomInfo.previousReadings[service.serviceId].year})</small>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <small class="text-muted">(Chỉ số ban đầu)</small>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <strong class="text-warning">0 ${service.unit}</strong>
                                                                                            <small class="text-muted">(Kỳ đầu tiên)</small>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </small>
                                                                            </div>
                                                                            
                                                                            <label class="form-label small">Chỉ số hiện tại (${service.unit})</label>
                                                                            <input type="number" 
                                                                                   class="form-control meter-reading-input" 
                                                                                   name="currentReading_${roomInfo.roomId}_${service.serviceId}" 
                                                                                   min="${roomInfo.previousReadings[service.serviceId] != null ? roomInfo.previousReadings[service.serviceId].reading : 0}" 
                                                                                   step="0.01" 
                                                                                   placeholder="Nhập chỉ số hiện tại"
                                                                                   data-room-id="${roomInfo.roomId}"
                                                                                   data-service-id="${service.serviceId}"
                                                                                   data-price="${service.pricePerUnit}"
                                                                                   data-service="${service.serviceName}"
                                                                                   data-previous-reading="${roomInfo.previousReadings[service.serviceId] != null ? roomInfo.previousReadings[service.serviceId].reading : 0}"
                                                                                   onchange="calculateMeterCost(this)"
                                                                                   required>
                                                                            
                                                                            <!-- Display consumption calculation -->
                                                                            <div class="mt-2">
                                                                                <small class="text-info">
                                                                                    <i class="bi bi-calculator me-1"></i>
                                                                                    Mức tiêu thụ: <span id="consumption-${roomInfo.roomId}-${service.serviceId}">0</span> ${service.unit}
                                                                                </small>
                                                                                <br>
                                                                                <small class="text-muted">
                                                                                    <i class="bi bi-info-circle me-1"></i>
                                                                                    Công thức: Chỉ số hiện tại - Chỉ số kỳ trước
                                                                                </small>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <!-- Quantity input for other services -->
                                                                            <label class="form-label small">
                                                                                <c:choose>
                                                                                    <c:when test="${service.unit == 'người'}">Số người (${service.unit})</c:when>
                                                                                    <c:when test="${service.unit == 'phòng'}">Số phòng (${service.unit})</c:when>
                                                                                    <c:when test="${service.unit == 'tháng'}">Số tháng (${service.unit})</c:when>
                                                                                    <c:otherwise>Số lượng (${service.unit})</c:otherwise>
                                                                                </c:choose>
                                                                            </label>
                                                                            
                                                                            <c:set var="existingQuantity" value="0" />
                                                                            <c:forEach var="usage" items="${roomInfo.existingUsages}">
                                                                                <c:if test="${usage.serviceId == service.serviceId}">
                                                                                    <c:set var="existingQuantity" value="${usage.quantity}" />
                                                                                </c:if>
                                                                            </c:forEach>
                                                                            
                                                                            <input type="number" 
                                                                                   class="form-control quantity-input" 
                                                                                   name="quantity_${roomInfo.roomId}_${service.serviceId}" 
                                                                                   value="${existingQuantity}"
                                                                                   min="0" 
                                                                                   step="0.01" 
                                                                                   placeholder="Nhập số lượng"
                                                                                   data-room-id="${roomInfo.roomId}"
                                                                                   data-service-id="${service.serviceId}"
                                                                                   data-price="${service.pricePerUnit}"
                                                                                   data-service="${service.serviceName}"
                                                                                   onchange="calculateQuantityCost(this)">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    
                                                                    <!-- Show cost for other services (will be calculated by JS) -->
                                                                    <div class="text-end mt-2">
                                                                        <small class="text-muted">Thành tiền:</small>
                                                                        <div class="service-cost h6 text-primary" id="cost-${roomInfo.roomId}-${service.serviceId}">
                                                                            0 VNĐ
                                                                        </div>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                </c:forEach>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-3">
                                                <i class="bi bi-info-circle fs-3 text-muted"></i>
                                                <p class="text-muted mt-2">Phòng này chưa có dịch vụ nào</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Additional Costs -->
                                    <c:if test="${not empty roomInfo.additionalCosts}">
                                        <div class="additional-costs">
                                            <h6><i class="bi bi-receipt-cutoff me-2"></i>Chi phí phát sinh:</h6>
                                            <c:forEach var="cost" items="${roomInfo.additionalCosts}">
                                                <div class="d-flex justify-content-between small">
                                                    <span>${cost.description}</span>
                                                    <span><fmt:formatNumber value="${cost.amount}" pattern="#,##0"/> VNĐ</span>
                                                </div>
                                            </c:forEach>
                                            <hr>
                                            <div class="d-flex justify-content-between">
                                                <strong>Tổng chi phí phát sinh:</strong>
                                                <strong><fmt:formatNumber value="${roomInfo.additionalTotal}" pattern="#,##0"/> VNĐ</strong>
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <!-- Room Total Preview -->
                                    <div class="mt-3 p-3 bg-light rounded-3">
                                        <h6 class="mb-3"><i class="bi bi-calculator me-2"></i>Tổng kết hóa đơn</h6>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <table class="table table-sm mb-0">
                                                    <tr>
                                                        <td class="border-0 py-1">
                                                            Tiền phòng:
                                                            <jsp:useBean id="dateUtil" class="java.util.Date" />
                                                            <c:set var="daysInMonth">
                                                                <c:choose>
                                                                    <c:when test="${month == 2}">
                                                                        <c:choose>
                                                                            <c:when test="${year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)}">29</c:when>
                                                                            <c:otherwise>28</c:otherwise>
                                                                        </c:choose>
                                                                    </c:when>
                                                                    <c:when test="${month == 4 || month == 6 || month == 9 || month == 11}">30</c:when>
                                                                    <c:otherwise>31</c:otherwise>
                                                                </c:choose>
                                                            </c:set>
                                                            
                                                            <c:set var="isProrated" value="false" />
                                                            <c:set var="earliestStartDay" value="1" />
                                                            
                                                            <c:forEach var="tenant" items="${roomInfo.tenants}">
                                                                <c:if test="${tenant.startDate != null}">
                                                                    <fmt:parseDate var="startDate" value="${tenant.startDate}" pattern="yyyy-MM-dd" />
                                                                    <fmt:formatDate var="startYear" value="${startDate}" pattern="yyyy" />
                                                                    <fmt:formatDate var="startMonth" value="${startDate}" pattern="M" />
                                                                    <c:if test="${startYear == year && startMonth == month}">
                                                                        <c:set var="isProrated" value="true" />
                                                                        <fmt:formatDate var="startDay" value="${startDate}" pattern="d" />
                                                                        <c:if test="${earliestStartDay == 1 || startDay < earliestStartDay}">
                                                                            <c:set var="earliestStartDay" value="${startDay}" />
                                                                        </c:if>
                                                                    </c:if>
                                                                </c:if>
                                                            </c:forEach>
                                                            
                                                            <c:if test="${isProrated}">
                                                                <c:set var="daysStayed" value="${daysInMonth - earliestStartDay + 1}" />
                                                                <br><small class="text-info">
                                                                    <i class="bi bi-calendar-check me-1"></i>
                                                                    ${daysStayed}/${daysInMonth} ngày
                                                                </small>
                                                            </c:if>
                                                        </td>
                                                        <td class="border-0 py-1 text-end fw-bold"><fmt:formatNumber value="${roomInfo.roomPrice}" pattern="#,##0"/> VNĐ</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="border-0 py-1">Tiền dịch vụ:</td>
                                                        <td class="border-0 py-1 text-end fw-bold" id="total-service-${roomInfo.roomId}">0 VNĐ</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="border-0 py-1">Chi phí phát sinh:</td>
                                                        <td class="border-0 py-1 text-end fw-bold"><fmt:formatNumber value="${roomInfo.additionalTotal}" pattern="#,##0"/> VNĐ</td>
                                                    </tr>
                                                    <tr class="border-top border-2">
                                                        <td class="py-2"><strong>Tổng tiền:</strong></td>
                                                        <td class="py-2 text-end text-primary h6 mb-0" id="grand-total-${roomInfo.roomId}">
                                                            <fmt:formatNumber value="${roomInfo.roomPrice + roomInfo.additionalTotal}" pattern="#,##0"/> VNĐ
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between mt-4">
                            <a href="${pageContext.request.contextPath}/admin/bills/generate" class="btn btn-secondary btn-lg">
                                <i class="bi bi-arrow-left me-2"></i>Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                                <i class="bi bi-check-circle me-2"></i>Tạo hóa đơn cho tất cả phòng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Calculate meter-based service cost
        function calculateMeterCost(input) {
            const roomId = input.dataset.roomId;
            const serviceId = input.dataset.serviceId;
            const currentReading = parseFloat(input.value) || 0;
            const pricePerUnit = parseFloat(input.dataset.price) || 0;
            const previousReading = parseFloat(input.dataset.previousReading) || 0;
            
            // Calculate consumption (current - previous)
            const consumption = Math.max(0, currentReading - previousReading);
            const cost = consumption * pricePerUnit;
            
            // Update consumption display
            const consumptionElement = document.getElementById('consumption-' + roomId + '-' + serviceId);
            if (consumptionElement) {
                consumptionElement.textContent = consumption.toFixed(2);
            }
            
            // Update cost display
            const costElement = document.getElementById('cost-' + roomId + '-' + serviceId);
            if (costElement) {
                costElement.textContent = new Intl.NumberFormat('vi-VN').format(cost) + ' VNĐ';
            }
            
            updateRoomTotal(roomId);
        }
        
        // Calculate quantity-based service cost
        function calculateQuantityCost(input) {
            const roomId = input.dataset.roomId;
            const serviceId = input.dataset.serviceId;
            const quantity = parseFloat(input.value) || 0;
            const pricePerUnit = parseFloat(input.dataset.price) || 0;
            const cost = quantity * pricePerUnit;
            
            // Update cost display
            const costElement = document.getElementById('cost-' + roomId + '-' + serviceId);
            if (costElement) {
                costElement.textContent = new Intl.NumberFormat('vi-VN').format(cost) + ' VNĐ';
            }
            
            updateRoomTotal(roomId);
        }
        
        // Update room total
        function updateRoomTotal(roomId) {
            let totalServiceCost = 0;
            
            // Sum all service costs for this room
            const serviceCostElements = document.querySelectorAll('[id^="cost-' + roomId + '-"]');
            serviceCostElements.forEach(element => {
                const costText = element.textContent.replace(/[^\d]/g, '');
                const cost = parseFloat(costText) || 0;
                totalServiceCost += cost;
            });
            
            // Update service total display
            const serviceTotalElement = document.getElementById('total-service-' + roomId);
            if (serviceTotalElement) {
                serviceTotalElement.textContent = new Intl.NumberFormat('vi-VN').format(totalServiceCost) + ' VNĐ';
            }
            
            // Get room price and additional cost from table rows
            const grandTotalElement = document.getElementById('grand-total-' + roomId);
            const table = grandTotalElement.closest('table');
            const rows = table.querySelectorAll('tr');
            
            let roomPrice = 0;
            let additionalCost = 0;
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                if (cells.length >= 2) {
                    const label = cells[0].textContent.trim();
                    const valueText = cells[1].textContent.replace(/[^\d]/g, '');
                    const value = parseFloat(valueText) || 0;
                    
                    if (label.includes('Tiền phòng')) {
                        roomPrice = value;
                    } else if (label.includes('Chi phí phát sinh')) {
                        additionalCost = value;
                    }
                }
            });
            
            const grandTotal = roomPrice + totalServiceCost + additionalCost;
            
            // Update grand total
            if (grandTotalElement) {
                grandTotalElement.textContent = new Intl.NumberFormat('vi-VN').format(grandTotal) + ' VNĐ';
            }
        }
        
        // Initialize calculations on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize existing quantity-based services
            const quantityInputs = document.querySelectorAll('.quantity-input');
            quantityInputs.forEach(input => {
                if (input.value) {
                    calculateQuantityCost(input);
                }
            });
            
            // Update totals for all rooms (including per-person services)
            const roomIds = document.querySelectorAll('input[name="roomIds"]');
            roomIds.forEach(input => {
                updateRoomTotal(input.value);
            });
        });
        
        // Form validation
        document.getElementById('bulkBillForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            
            // Disable submit button to prevent double submission
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Đang tạo hóa đơn...';
        });
    </script>
</body>
</html>