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
        
        .bill-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .service-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 15px;
            transition: transform 0.2s;
        }
        
        .service-card:hover {
            transform: translateY(-2px);
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
        
        .quantity-input {
            text-align: right;
            font-weight: bold;
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
                
                <!-- Generate Bill Services Content -->
                <div class="p-4">

        <!-- Bill Summary -->
        <div class="bill-summary">
            <div class="row">
                <div class="col-md-3">
                    <h6>Phòng:</h6>
                    <h5>${room.roomName}</h5>
                    <c:choose>
                        <c:when test="${isProrated}">
                            <small>Giá phòng: <fmt:formatNumber value="${proratedRoomPrice}" pattern="#,##0" /> VNĐ 
                                <span class="text-muted">(Tính theo tỷ lệ ngày ở)</span>
                            </small>
                            <br>
                            <small class="text-muted">Giá gốc: <fmt:formatNumber value="${fullRoomPrice}" pattern="#,##0" /> VNĐ/tháng</small>
                            <br>
                            <small class="text-info">
                                <i class="bi bi-calendar-check me-1"></i>
                                Đã ở: ${daysStayed}/${daysInMonth} ngày 
                                <c:if test="${earliestStartDate != null}">
                                    (từ <fmt:formatDate value="${earliestStartDate}" pattern="dd/MM/yyyy"/>)
                                </c:if>
                            </small>
                        </c:when>
                        <c:otherwise>
                            <small>Giá phòng: <fmt:formatNumber value="${room.price}" pattern="#,##0" /> VNĐ</small>
                            <br>
                            <small class="text-muted">
                                <i class="bi bi-calendar-check me-1"></i>
                                Cả tháng: ${daysInMonth} ngày
                            </small>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-md-3">
                    <h6>Người thuê:</h6>
                    <c:choose>
                        <c:when test="${not empty tenantsInRoom}">
                            <c:forEach var="tenant" items="${tenantsInRoom}" varStatus="status">
                                <div class="small">
                                    <i class="bi bi-person me-1"></i>${tenant.fullName}
                                    <c:if test="${!status.last}">, </c:if>
                                </div>
                            </c:forEach>
                            <small>${fn:length(tenantsInRoom)} người thuê</small>
                        </c:when>
                        <c:otherwise>
                            <h5 class="text-muted">Không có người thuê</h5>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-md-3">
                    <h6>Kỳ thanh toán:</h6>
                    <h5><fmt:formatNumber value="${month}" minIntegerDigits="2"/>/${year}</h5>
                </div>
                <div class="col-md-3">
                    <h6>Chi phí phát sinh:</h6>
                    <h5><fmt:formatNumber value="${additionalTotal}" pattern="#,##0" /> VNĐ</h5>
                    <small>${fn:length(additionalCosts)} khoản phát sinh</small>
                </div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/admin/bills/generate/final" method="post">
            <input type="hidden" name="roomId" value="${roomId}">
            <input type="hidden" name="month" value="${month}">
            <input type="hidden" name="year" value="${year}">

            <!-- Service Usage Input -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-speedometer2 me-2"></i>Nhập thông tin dịch vụ</h5>
                    <small class="text-muted">Nhập chỉ số công tơ cho điện/nước và số lượng cho các dịch vụ khác trong tháng ${month}/${year}</small>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty services}">
                            <div class="alert alert-info mb-3">
                                <i class="bi bi-info-circle me-2"></i>
                                <strong>Dịch vụ có sẵn cho phòng ${room.roomName}:</strong>
                                Hiển thị các dịch vụ được sử dụng trong phòng này. 
                                <c:if test="${fn:length(services) < 10}">Nếu cần thêm dịch vụ mới, vui lòng liên hệ quản trị viên.</c:if>
                                <br><br>

                            <div class="row">
                                <c:forEach var="service" items="${services}" varStatus="status">
                                    <div class="col-md-6 col-lg-4">
                                        <div class="service-card card h-100">
                                            <div class="card-body">

                                                
                                                <h6 class="card-title">
                                                    <c:choose>
                                                        <c:when test="${service.pricePerUnit == 0}">
                                                            <i class="bi bi-check-circle-fill text-success me-2"></i>
                                                        </c:when>
                                                        <c:when test="${service.unit == 'kWh'}">
                                                            <i class="bi bi-lightning-charge text-warning me-2"></i>
                                                        </c:when>
                                                        <c:when test="${service.unit == 'm³'}">
                                                            <i class="bi bi-droplet-fill text-primary me-2"></i>
                                                        </c:when>
                                                        <c:when test="${service.unit == 'người'}">
                                                            <i class="bi bi-people-fill text-info me-2"></i>
                                                        </c:when>
                                                        <c:when test="${service.unit == 'phòng'}">
                                                            <i class="bi bi-house-fill text-secondary me-2"></i>
                                                        </c:when>
                                                        <c:when test="${service.unit == 'tháng'}">
                                                            <i class="bi bi-calendar-month text-primary me-2"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-gear-fill text-dark me-2"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    ${service.serviceName}
                                                </h6>
                                                
                                                <div class="mb-3">
                                                    <c:choose>
                                                        <c:when test="${service.pricePerUnit == 0}">
                                                            <small class="text-success">
                                                                <i class="bi bi-check-circle me-1"></i>
                                                                <strong>Miễn phí</strong>
                                                            </small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-muted">
                                                                Đơn giá: <strong><fmt:formatNumber value="${service.pricePerUnit}" pattern="#,##0" /> VNĐ/${service.unit}</strong>
                                                            </small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <c:choose>
                                                        <c:when test="${service.pricePerUnit == 0}">
                                                            <!-- Free service - no input needed -->
                                                            <div class="text-success text-center py-3">
                                                                <i class="bi bi-check-circle-fill fs-2"></i>
                                                                <h6 class="mt-2">Dịch vụ miễn phí</h6>
                                                                <small class="text-muted">Không cần nhập dữ liệu</small>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${service.unit == 'kWh' || service.unit == 'm³'}">
                                                            <!-- Meter reading input for electricity and water -->
                                                            <label class="form-label small">Chỉ số công tơ hiện tại (${service.unit})</label>
                                                            
                                                            <!-- Display initial reading if available -->
                                                            <div class="mb-2">
                                                                <small class="text-muted">
                                                                    <i class="bi bi-speedometer me-1"></i>
                                                                    Chỉ số kỳ trước: 
                                                                    <c:choose>
                                                                        <c:when test="${initialReadings[service.serviceId] != null}">
                                                                            <span class="text-primary fw-bold">${initialReadings[service.serviceId].reading}</span> ${service.unit}
                                                                            <c:choose>
                                                                                <c:when test="${initialReadings[service.serviceId].month != null && initialReadings[service.serviceId].year != null && initialReadings[service.serviceId].month > 0}">
                                                                                    <small class="text-muted">(Kỳ ${initialReadings[service.serviceId].month}/${initialReadings[service.serviceId].year})</small>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <small class="text-muted">(Chỉ số ban đầu)</small>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-warning">0</span> ${service.unit}
                                                                            <small class="text-muted">(Kỳ đầu tiên)</small>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </small>
                                                            </div>
                                                            
                                                            <input type="number" 
                                                                   class="form-control meter-reading-input" 
                                                                   name="currentReadings" 
                                                                   min="${initialReadings[service.serviceId] != null ? initialReadings[service.serviceId].reading : 0}" 
                                                                   step="0.01" 
                                                                   placeholder="Nhập chỉ số hiện tại"
                                                                   data-price="${service.pricePerUnit}"
                                                                   data-service="${service.serviceName}"
                                                                   data-service-id="${service.serviceId}"
                                                                   data-previous-reading="${initialReadings[service.serviceId] != null ? initialReadings[service.serviceId].reading : 0}"
                                                                   data-has-meter="true"
                                                                   onchange="calculateConsumption(this)"
                                                                   required>
                                                            
                                                            <!-- Display calculated consumption -->
                                                            <div class="mt-2">
                                                                <small class="text-info">
                                                                    <i class="bi bi-calculator me-1"></i>
                                                                    Mức tiêu thụ: <span id="consumption-${service.serviceId}">0</span> ${service.unit}
                                                                </small>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-info-circle me-1"></i>
                                                                    Công thức: Chỉ số hiện tại - Chỉ số trước đó
                                                                </small>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <!-- Quantity input for other services -->
                                                            <label class="form-label small">
                                                                <c:choose>
                                                                    <c:when test="${service.unit == 'người'}">Số người sử dụng (${service.unit})</c:when>
                                                                    <c:when test="${service.unit == 'phòng'}">Số phòng sử dụng (${service.unit})</c:when>
                                                                    <c:when test="${service.unit == 'tháng'}">Số tháng sử dụng (${service.unit})</c:when>
                                                                    <c:otherwise>Số lượng sử dụng (${service.unit})</c:otherwise>
                                                                </c:choose>
                                                            </label>
                                                            
                                                            <c:set var="existingQuantity" value="0" />
                                                            <c:forEach var="usage" items="${existingUsages}">
                                                                <c:if test="${usage.serviceId == service.serviceId}">
                                                                    <c:set var="existingQuantity" value="${usage.quantity}" />
                                                                </c:if>
                                                            </c:forEach>
                                                            
                                                            <input type="number" 
                                                                   class="form-control quantity-input" 
                                                                   name="quantities" 
                                                                   value="${existingQuantity}"
                                                                   min="0" 
                                                                   step="0.01" 
                                                                   placeholder="Nhập số lượng"
                                                                   data-price="${service.pricePerUnit}"
                                                                   data-service="${service.serviceName}"
                                                                   data-service-id="${service.serviceId}"
                                                                   data-has-meter="false"
                                                                   onchange="calculateServiceCost(this)">
                                                            
                                                            <div class="form-text small">
                                                                <c:choose>
                                                                    <c:when test="${service.unit == 'người'}">
                                                                        Nhập số người sử dụng ${service.serviceName.toLowerCase()} (thường là ${fn:length(tenantsInRoom)} người)
                                                                    </c:when>
                                                                    <c:when test="${service.unit == 'phòng'}">
                                                                        Nhập số phòng sử dụng ${service.serviceName.toLowerCase()} (thường là 1 phòng)
                                                                    </c:when>
                                                                    <c:when test="${service.unit == 'tháng'}">
                                                                        Nhập số tháng sử dụng ${service.serviceName.toLowerCase()} (thường là 1 tháng)
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Nhập số lượng sử dụng ${service.serviceName.toLowerCase()}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                    <!-- Hidden input for service IDs (only for non-free services) -->
                                                    <c:if test="${service.pricePerUnit != 0}">
                                                        <input type="hidden" name="serviceIds" value="${service.serviceId}">
                                                    </c:if>
                                                </div>
                                                
                                                <!-- Only show cost calculation for non-free services -->
                                                <c:if test="${service.pricePerUnit != 0}">
                                                    <div class="text-end">
                                                        <small class="text-muted">Thành tiền:</small>
                                                        <div class="service-cost h6 text-primary" id="cost-${service.serviceId}">
                                                            0 VNĐ
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-4">
                                <i class="bi bi-info-circle fs-1 text-muted"></i>
                                <h5 class="text-muted mt-3">Chưa có dịch vụ nào cho phòng ${room.roomName}</h5>
                                <p class="text-muted">Phòng này chưa sử dụng dịch vụ nào. Bạn có thể:</p>
                                <ul class="list-unstyled text-muted">
                                    <li><i class="bi bi-arrow-right me-2"></i>Thêm dữ liệu sử dụng dịch vụ trước đây qua <a href="${pageContext.request.contextPath}/admin/service-usage/add">Quản lý Sử dụng Dịch vụ</a></li>
                                    <li><i class="bi bi-arrow-right me-2"></i>Hoặc tạo hóa đơn chỉ với tiền phòng và chi phí phát sinh</li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Bill Preview -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-calculator me-2"></i>Xem trước hóa đơn</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <table class="table table-borderless">
                                <tr>
                                    <td>
                                        Tiền phòng:
                                        <c:choose>
                                            <c:when test="${isProrated}">
                                                <br><small class="text-muted">(${daysStayed}/${daysInMonth} ngày)</small>
                                            </c:when>
                                            <c:otherwise>
                                                <br><small class="text-muted">(Cả tháng)</small>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <c:choose>
                                            <c:when test="${isProrated}">
                                                <fmt:formatNumber value="${proratedRoomPrice}" pattern="#,##0" /> VNĐ
                                                <br><small class="text-muted">(<fmt:formatNumber value="${fullRoomPrice}" pattern="#,##0" /> VNĐ × ${daysStayed}/${daysInMonth})</small>
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${room.price}" pattern="#,##0" /> VNĐ
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tiền dịch vụ:</td>
                                    <td class="text-end" id="total-service-cost">0 VNĐ</td>
                                </tr>
                                <tr>
                                    <td>Chi phí phát sinh:</td>
                                    <td class="text-end"><fmt:formatNumber value="${additionalTotal}" pattern="#,##0" /> VNĐ</td>
                                </tr>
                                <tr class="border-top">
                                    <th>Tổng tiền:</th>
                                    <th class="text-end text-primary h5" id="grand-total">
                                        <c:choose>
                                            <c:when test="${isProrated}">
                                                <fmt:formatNumber value="${proratedRoomPrice + additionalTotal}" pattern="#,##0" /> VNĐ
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatNumber value="${room.price + additionalTotal}" pattern="#,##0" /> VNĐ
                                            </c:otherwise>
                                        </c:choose>
                                    </th>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-4">
                            <c:if test="${not empty additionalCosts}">
                                <h6>Chi phí phát sinh:</h6>
                                <c:forEach var="cost" items="${additionalCosts}">
                                    <div class="d-flex justify-content-between small">
                                        <span>${cost.description}</span>
                                        <span><fmt:formatNumber value="${cost.amount}" pattern="#,##0" /> VNĐ</span>
                                    </div>
                                </c:forEach>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/admin/bills/generate" class="btn btn-secondary">
                    <i class="bi bi-arrow-left me-2"></i>Quay lại
                </a>
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="bi bi-check-circle me-2"></i>Tạo hóa đơn
                </button>
            </div>
        </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const roomPrice = ${isProrated ? proratedRoomPrice : room.price};
        const fullRoomPrice = ${fullRoomPrice};
        const isProrated = ${isProrated};
        const additionalTotal = ${additionalTotal};
        const roomId = ${roomId};
        const month = ${month};
        const year = ${year};
        const contextPath = '${pageContext.request.contextPath}';
        

        
        // Tính toán mức tiêu thụ cho dịch vụ có công tơ
        function calculateConsumption(input) {
            const currentReading = parseFloat(input.value) || 0;
            const serviceId = input.dataset.serviceId;
            const pricePerUnit = parseFloat(input.dataset.price) || 0;
            const previousReading = parseFloat(input.dataset.previousReading) || 0;
            
            // Tính mức tiêu thụ (hiện tại - trước đó)
            const consumption = Math.max(0, currentReading - previousReading);
            const cost = consumption * pricePerUnit;
            
            // Cập nhật hiển thị mức tiêu thụ
            const consumptionElement = document.getElementById('consumption-' + serviceId);
            if (consumptionElement) {
                consumptionElement.textContent = consumption.toFixed(2);
            }
            
            // Cập nhật thành tiền
            const costElement = document.getElementById('cost-' + serviceId);
            if (costElement) {
                costElement.textContent = new Intl.NumberFormat('vi-VN').format(cost) + ' VNĐ';
            }
            
            updateTotalServiceCost();
        }
        
        // Tính toán chi phí dịch vụ khác
        function calculateServiceCost(input) {
            const quantity = parseFloat(input.value) || 0;
            const serviceId = input.dataset.serviceId;
            const pricePerUnit = parseFloat(input.dataset.price) || 0;
            const cost = quantity * pricePerUnit;
            
            // Cập nhật thành tiền
            const costElement = document.getElementById('cost-' + serviceId);
            if (costElement) {
                costElement.textContent = new Intl.NumberFormat('vi-VN').format(cost) + ' VNĐ';
            }
            
            updateTotalServiceCost();
        }
        
        // Cập nhật tổng tiền real-time
        function updateTotalServiceCost() {
            let totalServiceCost = 0;
            
            // Tính tổng từ các dịch vụ có công tơ
            const readingInputs = document.querySelectorAll('input[name="currentReadings"]');
            readingInputs.forEach(input => {
                const currentReading = parseFloat(input.value) || 0;
                const serviceId = input.dataset.serviceId;
                const pricePerUnit = parseFloat(input.dataset.price) || 0;
                const previousReading = parseFloat(input.dataset.previousReading) || 0;
                const consumption = Math.max(0, currentReading - previousReading);
                totalServiceCost += consumption * pricePerUnit;
            });
            
            // Tính tổng từ các dịch vụ theo số lượng
            const quantityInputs = document.querySelectorAll('input[name="quantities"]');
            quantityInputs.forEach(input => {
                const quantity = parseFloat(input.value) || 0;
                const pricePerUnit = parseFloat(input.dataset.price) || 0;
                totalServiceCost += quantity * pricePerUnit;
            });
            
            // Cập nhật hiển thị
            document.getElementById('total-service-cost').textContent = 
                new Intl.NumberFormat('vi-VN').format(totalServiceCost) + ' VNĐ';
            
            // Cập nhật tổng tiền cuối cùng
            const grandTotal = roomPrice + totalServiceCost + additionalTotal;
            document.getElementById('grand-total').textContent = 
                new Intl.NumberFormat('vi-VN').format(grandTotal) + ' VNĐ';
        }
        
        // Khởi tạo các giá trị ban đầu
        function initializeServiceCosts() {
            // Initialize costs for quantity-based services
            const quantityInputs = document.querySelectorAll('input[name="quantities"]');
            quantityInputs.forEach(input => {
                if (input.value) {
                    calculateServiceCost(input);
                }
            });
        }
        
        // Initialize calculations on page load
        document.addEventListener('DOMContentLoaded', function() {
            initializeServiceCosts();
            updateTotalServiceCost();
        });
    </script>
</body>
</html>
