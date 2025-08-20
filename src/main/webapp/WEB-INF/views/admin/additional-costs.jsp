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
        
        .stats-cards .card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        
        .stats-cards .card:hover {
            transform: translateY(-2px);
        }
        
        .stats-cards .card.border-warning {
            border-left-color: #ffc107 !important;
        }
        
        .stats-cards .card.border-success {
            border-left-color: #28a745 !important;
        }
        
        .stats-cards .card.border-info {
            border-left-color: #17a2b8 !important;
        }
        
        .search-form {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .cost-description {
            max-width: 250px;
            word-wrap: break-word;
        }
        
        .tenant-info {
            font-size: 0.9em;
        }
        
        .amount-display {
            font-weight: 600;
            font-size: 1.1em;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/additional-costs">
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile/change-password">Đổi mật khẩu</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Additional Costs Content -->
                <div class="p-4">
                    <!-- Statistics Cards -->
                    <div class="stats-cards row mb-4">
                        <div class="col-md-4 mb-3">
                            <div class="card border-warning">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Tổng chi phí phát sinh</h6>
                                            <h3 class="mb-0 text-warning">${additionalCosts.size()}</h3>
                                        </div>
                                        <div class="text-warning">
                                            <i class="bi bi-receipt-cutoff fs-1"></i>
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
                                            <h6 class="text-muted mb-1">Tháng này</h6>
                                            <h3 class="mb-0 text-success">
                                                <c:set var="thisMonthCount" value="0" />
                                                <c:forEach var="cost" items="${additionalCosts}">
                                                    <fmt:formatDate var="costMonth" value="${cost.date}" pattern="MM/yyyy" />
                                                    <fmt:formatDate var="currentMonth" value="<%=new java.util.Date()%>" pattern="MM/yyyy" />
                                                    <c:if test="${costMonth == currentMonth}">
                                                        <c:set var="thisMonthCount" value="${thisMonthCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${thisMonthCount}
                                            </h3>
                                        </div>
                                        <div class="text-success">
                                            <i class="bi bi-calendar-check fs-1"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card border-info">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h6 class="text-muted mb-1">Tổng tiền (tháng này)</h6>
                                            <h5 class="mb-0 text-info">
                                                <c:set var="thisMonthTotal" value="0" />
                                                <c:forEach var="cost" items="${additionalCosts}">
                                                    <fmt:formatDate var="costMonth" value="${cost.date}" pattern="MM/yyyy" />
                                                    <fmt:formatDate var="currentMonth" value="<%=new java.util.Date()%>" pattern="MM/yyyy" />
                                                    <c:if test="${costMonth == currentMonth}">
                                                        <c:set var="thisMonthTotal" value="${thisMonthTotal + cost.amount}" />
                                                    </c:if>
                                                </c:forEach>
                                                <fmt:formatNumber value="${thisMonthTotal}" 
                                                                type="currency" 
                                                                currencySymbol="₫" 
                                                                groupingUsed="true"/>
                                            </h5>
                                        </div>
                                        <div class="text-info">
                                            <i class="bi bi-cash-coin fs-1"></i>
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
                                <form method="GET" action="${pageContext.request.contextPath}/admin/additional-costs">
                                    <div class="input-group">
                                        <input type="text" 
                                               class="form-control" 
                                               name="search" 
                                               placeholder="Tìm kiếm theo tên khách thuê hoặc mô tả..." 
                                               value="${searchTerm}">
                                        <button class="btn btn-outline-secondary" type="submit">
                                            <i class="bi bi-search"></i>
                                        </button>
                                        <c:if test="${not empty searchTerm}">
                                            <a href="${pageContext.request.contextPath}/admin/additional-costs" 
                                               class="btn btn-outline-warning">
                                                <i class="bi bi-x-circle"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </form>
                                <c:if test="${not empty searchTerm}">
                                    <small class="text-muted mt-1 d-block">
                                        Tìm thấy ${additionalCosts.size()} kết quả cho "${searchTerm}"
                                    </small>
                                </c:if>
                            </div>
                            <div class="col-md-6 text-end">
                                <a href="${pageContext.request.contextPath}/admin/additional-costs/add" 
                                   class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-1"></i>
                                    Thêm Chi phí phát sinh
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
                    
                    <!-- Additional Costs Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-list me-2"></i>
                                Danh sách Chi phí phát sinh
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty additionalCosts}">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th width="60">#</th>
                                                    <th>Khách thuê</th>
                                                    <th>Phòng</th>
                                                    <th width="250">Mô tả</th>
                                                    <th width="120">Số tiền</th>
                                                    <th width="120">Ngày phát sinh</th>
                                                    <th width="180" class="text-center">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="cost" items="${additionalCosts}" varStatus="status">
                                                    <tr>
                                                        <td class="align-middle">
                                                            <span class="badge bg-secondary">${cost.costId}</span>
                                                        </td>
                                                        <td class="align-middle">
                                                            <div class="tenant-info">
                                                                <strong>${cost.tenantName}</strong>
                                                                <br>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-person-badge me-1"></i>
                                                                    ID: ${cost.tenantId}
                                                                </small>
                                                            </div>
                                                        </td>
                                                        <td class="align-middle">
                                                            <strong class="text-primary">${cost.roomName}</strong>
                                                        </td>
                                                        <td class="align-middle">
                                                            <div class="cost-description">
                                                                <span title="${cost.description}">
                                                                    ${cost.description}
                                                                </span>
                                                            </div>
                                                        </td>
                                                        <td class="align-middle">
                                                            <span class="amount-display text-danger">
                                                                <fmt:formatNumber value="${cost.amount}" 
                                                                                type="currency" 
                                                                                currencySymbol="₫" 
                                                                                groupingUsed="true"/>
                                                            </span>
                                                        </td>
                                                        <td class="align-middle">
                                                            <fmt:formatDate value="${cost.date}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td class="align-middle text-center">
                                                            <div class="btn-group btn-group-sm" role="group">
                                                                <a href="${pageContext.request.contextPath}/admin/additional-costs/view/${cost.costId}" 
                                                                   class="btn btn-outline-info" 
                                                                   title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/additional-costs/edit/${cost.costId}" 
                                                                   class="btn btn-outline-primary" 
                                                                   title="Chỉnh sửa">
                                                                    <i class="bi bi-pencil"></i>
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-outline-danger" 
                                                                        title="Xóa"
                                                                        onclick="confirmDelete(${cost.costId}, '${cost.description}')">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
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
                                        <i class="bi bi-receipt-cutoff text-muted" style="font-size: 4rem;"></i>
                                        <h5 class="text-muted mt-3">Chưa có chi phí phát sinh nào</h5>
                                        <p class="text-muted">Hãy thêm chi phí phát sinh đầu tiên cho hệ thống</p>
                                        <a href="${pageContext.request.contextPath}/admin/additional-costs/add" 
                                           class="btn btn-primary">
                                            <i class="bi bi-plus-circle me-1"></i>
                                            Thêm Chi phí phát sinh
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                        Xác nhận xóa
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa chi phí phát sinh này không?</p>
                    <div class="alert alert-warning">
                        <strong>Chi phí:</strong> <span id="deleteDescription"></span><br>
                        <strong>Lưu ý:</strong> Thao tác này không thể hoàn tác!
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="POST" style="display: inline;">
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-trash me-1"></i>
                            Xóa chi phí
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(costId, description) {
            document.getElementById('deleteDescription').textContent = description;
            document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/admin/additional-costs/delete/' + costId;
            
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>
