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
        
        .info-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-icon {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            color: #667eea;
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
        }
        
        .info-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            color: #666;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .status-active {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }
        
        .status-inactive {
            background: rgba(108, 117, 125, 0.1);
            color: #6c757d;
        }
        
        .room-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        
        .room-icon {
            background: rgba(255, 255, 255, 0.2);
            width: 100px;
            height: 100px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 3rem;
        }
        
        .status-available {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }
        
        .badge-occupied {
            background: #007bff;
        }
        
        .room-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 100px;
            height: 100px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 2.5rem;
            margin: 0 auto 20px;
        }
        
        .tenant-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        
        .tenant-card:hover {
            transform: translateY(-2px);
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
        
        .service-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            margin: 0.25rem;
            display: inline-block;
        }
        
        .badge-active {
            background: #28a745;
            color: white;
        }
        
        .badge-warning {
            background: #ffc107;
            color: #212529;
        }
        
        .badge-inactive {
            background: #6c757d;
            color: white;
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
                
                <!-- Tenant Detail Content -->
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
                            <li class="breadcrumb-item active" aria-current="page">Chi tiết thuê trọ</li>
                        </ol>
                    </nav>
                    
                    <!-- Room Profile Card -->
                    <div class="info-card">
                        <div class="text-center">
                            <div class="room-avatar">
                                <i class="bi bi-door-open"></i>
                            </div>
                            <h3>${room.roomName}</h3>
                            <c:choose>
                                <c:when test="${room.status == 'AVAILABLE'}">
                                    <span class="badge badge-available fs-6">Phòng trống</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-occupied fs-6">Đang có người thuê</span>
                                </c:otherwise>
                            </c:choose>
                            <br><br>
                            <!-- Room Payment Status -->
                            <c:choose>
                                <c:when test="${room.paymentStatus != null and fn:startsWith(room.paymentStatus, 'UNPAID')}">
                                    <span class="badge bg-danger fs-6">
                                        <i class="bi bi-exclamation-triangle me-1"></i>
                                        Phòng đang nợ
                                    </span>
                                    <c:if test="${not empty room.unpaidPeriodsString}">
                                        <div class="mt-2">
                                            <small class="text-danger">
                                                <i class="bi bi-credit-card me-1"></i>
                                                <strong>Các kỳ nợ:</strong> ${room.unpaidPeriodsString}
                                            </small>
                                        </div>
                                    </c:if>
                                </c:when>
                                <c:when test="${tenantCount > 0}">
                                    <span class="badge bg-success fs-6">
                                        <i class="bi bi-check-circle me-1"></i>
                                        Phòng đã thanh toán
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary fs-6">
                                        <i class="bi bi-dash-circle me-1"></i>
                                        Chưa có người thuê
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <div class="row">
                        <!-- Room Information -->
                        <div class="col-lg-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-info-circle me-2"></i>
                                        Thông tin phòng
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-house-door"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="info-label">Tên phòng</div>
                                            <div class="info-value">${room.roomName}</div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-currency-dollar"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="info-label">Giá phòng/tháng</div>
                                            <div class="info-value text-success fw-bold">
                                                <fmt:formatNumber value="${room.price}" 
                                                                type="currency" 
                                                                currencySymbol="₫" 
                                                                groupingUsed="true"/>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-people"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="info-label">Số người hiện tại</div>
                                            <div class="info-value">${tenantCount}/4 người</div>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item">
                                        <div class="info-icon">
                                            <i class="bi bi-check-circle"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="info-label">Trạng thái</div>
                                            <div class="info-value">
                                                <c:choose>
                                                    <c:when test="${room.status == 'AVAILABLE'}">
                                                        <span class="text-success">Có sẵn</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-primary">Đang thuê</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty room.description}">
                                        <div class="info-item">
                                            <div class="info-icon">
                                                <i class="bi bi-card-text"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="info-label">Mô tả</div>
                                                <div class="info-value">${room.description}</div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Services -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-tools me-2"></i>
                                        Dịch vụ có sẵn
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty roomServices}">
                                            <c:forEach var="service" items="${roomServices}">
                                                <span class="service-badge">
                                                    <i class="bi bi-check-circle me-1"></i>
                                                    ${service}
                                                </span>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted mb-0">
                                                <i class="bi bi-info-circle me-1"></i>
                                                Chưa có dịch vụ nào được thiết lập
                                            </p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Tenants List -->
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="mb-0">
                                        <i class="bi bi-people me-2"></i>
                                        Danh sách khách thuê (${tenantCount}/4)
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty roomTenants}">
                                            <c:forEach var="tenant" items="${roomTenants}">
                                                <div class="tenant-card">
                                                    <div class="row align-items-center">
                                                        <div class="col-auto">
                                                            <div class="tenant-avatar">
                                                                ${tenant.fullName.substring(0, 1).toUpperCase()}
                                                            </div>
                                                        </div>
                                                        <div class="col">
                                                            <h6 class="mb-1">${tenant.fullName}</h6>
                                                            <p class="text-muted mb-1">
                                                                <i class="bi bi-telephone me-1"></i>
                                                                <c:choose>
                                                                    <c:when test="${not empty tenant.phone}">
                                                                        ${tenant.phone}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Chưa cập nhật
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </p>
                                                            <p class="text-muted mb-1">
                                                                <i class="bi bi-calendar me-1"></i>
                                                                Từ: <fmt:formatDate value="${tenant.startDate}" pattern="dd/MM/yyyy"/>
                                                            </p>
                                                            <span class="badge ${tenant.statusBadgeClass}">
                                                                ${tenant.detailedStatus}
                                                            </span>
                                                        </div>
                                                        <div class="col-auto">
                                                            <div class="btn-group-vertical" role="group">
                                                                <c:if test="${tenant.active}">
                                                                    <a href="${pageContext.request.contextPath}/admin/tenants/change-room/${tenant.tenantId}" 
                                                                       class="btn btn-sm btn-warning mb-1">
                                                                        <i class="bi bi-arrow-left-right me-1"></i>
                                                                        Đổi phòng
                                                                    </a>
                                                                    
                                                                    <button type="button" 
                                                                            class="btn btn-sm btn-danger" 
                                                                            onclick="confirmEndLease(${tenant.tenantId}, '${tenant.fullName}')">
                                                                        <i class="bi bi-stop-circle me-1"></i>
                                                                        Kết thúc
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="bi bi-house text-muted" style="font-size: 4rem;"></i>
                                                <h5 class="text-muted mt-3">Phòng trống</h5>
                                                <p class="text-muted">Hiện tại chưa có ai thuê phòng này</p>
                                                <a href="${pageContext.request.contextPath}/admin/tenants/add?roomId=${room.roomId}" 
                                                   class="btn btn-primary">
                                                    <i class="bi bi-plus-circle me-2"></i>
                                                    Thêm khách thuê
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Action Buttons -->
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex gap-2 justify-content-center flex-wrap">
                                <a href="${pageContext.request.contextPath}/admin/tenants" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>
                                    Quay lại danh sách
                                </a>
                                
                                <c:if test="${tenantCount < 4}">
                                    <a href="${pageContext.request.contextPath}/admin/tenants/add?roomId=${room.roomId}" 
                                       class="btn btn-success">
                                        <i class="bi bi-plus-circle me-2"></i>
                                        Thêm khách thuê
                                    </a>
                                </c:if>
                                
                                <a href="${pageContext.request.contextPath}/admin/rooms/edit/${room.roomId}" 
                                   class="btn btn-warning">
                                    <i class="bi bi-gear me-2"></i>
                                    Cài đặt phòng
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- End Lease Modal -->
    <div class="modal fade" id="endLeaseModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận kết thúc hợp đồng thuê</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn kết thúc hợp đồng thuê của <strong id="tenantNameToEnd"></strong>?</p>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">Ngày kết thúc (để trống = hôm nay)</label>
                        <input type="date" class="form-control" id="endDate" name="endDate">
                    </div>
                    <p class="text-warning">
                        <i class="bi bi-exclamation-triangle me-1"></i>
                        Phòng sẽ được chuyển về trạng thái "Có sẵn" sau khi kết thúc hợp đồng!
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form id="endLeaseForm" method="POST" style="display: inline;">
                        <input type="hidden" id="endDateInput" name="endDate">
                        <button type="submit" class="btn btn-danger">Kết thúc hợp đồng</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmEndLease(tenantId, tenantName) {
            document.getElementById('tenantNameToEnd').textContent = tenantName;
            document.getElementById('endLeaseForm').action = '${pageContext.request.contextPath}/admin/tenants/end/' + tenantId;
            
            var endLeaseModal = new bootstrap.Modal(document.getElementById('endLeaseModal'));
            endLeaseModal.show();
            
            // Set today as default end date
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('endDate').value = today;
        }
        
        // Update hidden input when date changes
        document.getElementById('endDate').addEventListener('change', function() {
            document.getElementById('endDateInput').value = this.value;
        });
        
        // Set default value on form submit
        document.getElementById('endLeaseForm').addEventListener('submit', function() {
            const endDate = document.getElementById('endDate').value;
            document.getElementById('endDateInput').value = endDate;
        });
    </script>
</body>
</html>
