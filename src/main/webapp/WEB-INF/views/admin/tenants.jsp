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
        
        .table th {
            background: #f8f9fa;
            border-top: none;
            font-weight: 600;
        }
        
        .badge-active {
            background: #28a745;
        }
        
        .badge-inactive {
            background: #6c757d;
        }
        
        .tenant-actions {
            white-space: nowrap;
        }
        
        .stats-cards .card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        
        .stats-cards .card:hover {
            transform: translateY(-2px);
        }
        
        .stats-cards .card.border-primary {
            border-left-color: #667eea !important;
        }
        
        .stats-cards .card.border-success {
            border-left-color: #28a745 !important;
        }
        
        .stats-cards .card.border-secondary {
            border-left-color: #6c757d !important;
        }
        
        .search-form {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .services-display {
            font-size: 0.85em;
            line-height: 1.3;
            max-width: 200px;
            word-wrap: break-word;
        }
        
        .services-display small {
            display: block;
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
                
                <!-- Tenant Management Content -->
                <div class="p-4">
                    <!-- Statistics Cards -->
                    <div class="stats-cards row mb-4">
                        <div class="col-md-4 mb-3">
                            <div class="card border-primary">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Tổng số thuê trọ</h6>
                                            <h3 class="mb-0 text-primary">${totalTenants}</h3>
                                        </div>
                                        <div class="text-primary">
                                            <i class="bi bi-people fs-1"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-success">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Đang thuê</h6>
                                            <h3 class="mb-0 text-success">${activeTenants}</h3>
                                        </div>
                                        <div class="text-success">
                                            <i class="bi bi-person-check fs-1"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-secondary">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Đã kết thúc</h6>
                                            <h3 class="mb-0 text-secondary">${inactiveTenants}</h3>
                                        </div>
                                        <div class="text-secondary">
                                            <i class="bi bi-person-x fs-1"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Search and Filter -->
                    <div class="search-form mb-4">
                        <div class="row align-items-end">
                            <div class="col-md-6">
                                <form method="GET" action="${pageContext.request.contextPath}/admin/tenants">
                                    <div class="input-group">
                                        <input type="text" 
                                               class="form-control" 
                                               name="search" 
                                               placeholder="Tìm kiếm theo tên hoặc phòng..." 
                                               value="${searchTerm}">
                                        <input type="hidden" name="status" value="${selectedStatus}">
                                        <button class="btn btn-outline-secondary" type="submit">
                                            <i class="bi bi-search"></i>
                                        </button>
                                        <c:if test="${not empty searchTerm}">
                                            <a href="${pageContext.request.contextPath}/admin/tenants?status=${selectedStatus}" 
                                               class="btn btn-outline-warning">
                                                <i class="bi bi-x-circle"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                                <c:if test="${not empty searchTerm}">
                                    <small class="text-muted mt-1 d-block">
                                        Tìm thấy ${tenants.size()} kết quả cho "${searchTerm}"
                                    </small>
                                </c:if>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" onchange="filterByStatus(this.value)">
                                    <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>Tất cả</option>
                                    <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Đang thuê</option>
                                </select>
                            </div>
                            <div class="col-md-3 text-end">
                                <a href="${pageContext.request.contextPath}/admin/tenants/add" 
                                   class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-1"></i>
                                    Thêm Thuê trọ mới
                                </a>
                            </div>
                        </div>
                    </div>
                    
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
                    
                    <!-- Tenants Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-list me-2"></i>
                                Danh sách Thuê trọ
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty tenants}">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th width="60">#</th>
                                                    <th>Tên khách thuê</th>
                                                    <th>Phòng</th>
                                                    <th>Số người/Phòng</th>
                                                    <th>Giá phòng</th>
                                                    <th width="200">Dịch vụ đã chọn</th>
                                                    <th width="120">Ngày bắt đầu</th>
                                                    <th width="120">Ngày kết thúc</th>
                                                    <th width="100">Trạng thái</th>
                                                    <th width="180" class="text-center">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="tenant" items="${tenants}" varStatus="status">
                                                    <tr>
                                                        <td class="align-middle">
                                                            <span class="badge bg-secondary">${tenant.tenantId}</span>
                                                        </td>
                                                        <td class="align-middle">
                                                            <div>
                                                                <strong>${tenant.fullName}</strong>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-telephone me-1"></i>
                                                                    ${not empty tenant.phone ? tenant.phone : 'Chưa có'}
                                                                </small>
                                                            </div>
                                                        </td>
                                                        <td class="align-middle">
                                                            <strong>${tenant.roomName}</strong>
                                                        </td>
                                                        <td class="align-middle">
                                                            <c:set var="roomTenantCount" value="${roomTenantCounts[tenant.roomId]}" />
                                                            <span class="badge bg-info">
                                                                ${roomTenantCount != null ? roomTenantCount : 1}/4 người
                                                            </span>
                                                            <c:if test="${roomTenantCount >= 4}">
                                                                <br><small class="text-warning"><i class="bi bi-exclamation-triangle me-1"></i>Đầy phòng</small>
                                                            </c:if>
                                                        </td>
                                                        <td class="align-middle">
                                                            <span class="fw-bold text-success">
                                                                <fmt:formatNumber value="${tenant.roomPrice}" 
                                                                                type="currency" 
                                                                                currencySymbol="₫" 
                                                                                groupingUsed="true"/>
                                                            </span>
                                                        </td>
                                                        <td class="align-middle">
                                                            <div class="services-display">
                                                                <c:set var="servicesDisplay" value="${tenantServicesMap[tenant.tenantId]}"/>
                                                                <c:choose>
                                                                    <c:when test="${not empty servicesDisplay and servicesDisplay != 'Không có dịch vụ'}">
                                                                        <small class="text-info">
                                                                            <i class="bi bi-tools me-1"></i>
                                                                            ${servicesDisplay}
                                                                        </small>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <small class="text-muted">
                                                                            <i class="bi bi-dash-circle me-1"></i>
                                                                            Không có dịch vụ
                                                                        </small>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                        <td class="align-middle">
                                                            <fmt:formatDate value="${tenant.startDate}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td class="align-middle">
                                                            <c:choose>
                                                                <c:when test="${tenant.endDate != null}">
                                                                    <fmt:formatDate value="${tenant.endDate}" pattern="dd/MM/yyyy"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="align-middle">
                                                            <c:choose>
                                                                <c:when test="${tenant.active}">
                                                                    <span class="badge badge-active">Đang thuê</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-inactive">Đã kết thúc</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="align-middle tenant-actions text-center">
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/admin/tenants/view/${tenant.tenantId}" 
                                                                   class="btn btn-outline-info btn-sm" 
                                                                   title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                                <c:if test="${tenant.active}">
                                                                    <a href="${pageContext.request.contextPath}/admin/tenants/change-room/${tenant.tenantId}" 
                                                                       class="btn btn-outline-warning btn-sm" 
                                                                       title="Đổi phòng">
                                                                        <i class="bi bi-arrow-left-right"></i>
                                                                    </a>
                                                                    <button type="button" 
                                                                            class="btn btn-outline-danger btn-sm" 
                                                                            title="Kết thúc hợp đồng"
                                                                            onclick="confirmEndLease(${tenant.tenantId}, '${tenant.fullName}')">
                                                                        <i class="bi bi-stop-circle"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="bi bi-person-check text-muted" style="font-size: 3rem;"></i>
                                        <h5 class="text-muted mt-3">
                                            <c:choose>
                                                <c:when test="${not empty searchTerm}">
                                                    Không tìm thấy khách thuê nào với từ khóa "${searchTerm}"
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa có khách thuê nào
                                                </c:otherwise>
                                            </c:choose>
                                        </h5>
                                        <p class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty searchTerm}">
                                                    Thử tìm kiếm với từ khóa khác hoặc 
                                                    <a href="${pageContext.request.contextPath}/admin/tenants">xem tất cả</a>
                                                </c:when>
                                                <c:otherwise>
                                                    Bắt đầu bằng cách thêm khách thuê đầu tiên
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <c:if test="${empty searchTerm}">
                                            <a href="${pageContext.request.contextPath}/admin/tenants/add" 
                                               class="btn btn-primary">
                                                <i class="bi bi-plus-circle me-1"></i>
                                                Thêm Thuê trọ mới
                                            </a>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- End Lease Confirmation Modal -->
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
        function filterByStatus(status) {
            const url = new URL(window.location.href);
            url.searchParams.set('status', status);
            url.searchParams.delete('search'); // Clear search when filtering
            window.location.href = url.toString();
        }
        
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
