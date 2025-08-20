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
        
        .detail-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
        }
        
        .detail-header {
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border: 2px solid #667eea;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .cost-amount {
            font-size: 2rem;
            font-weight: bold;
            color: #dc3545;
        }
        
        .detail-section {
            border-left: 4px solid #667eea;
            padding-left: 20px;
            margin-bottom: 25px;
        }
        
        .section-title {
            color: #667eea;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .info-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: #6c757d;
        }
        
        .tenant-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 2rem;
        }
        
        .status-badge {
            font-size: 1.1rem;
            padding: 8px 16px;
        }
        
        .action-buttons {
            position: sticky;
            top: 20px;
        }
        
        .cost-timeline {
            border-left: 3px solid #667eea;
            padding-left: 20px;
            position: relative;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -27px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #667eea;
        }
        
        .highlight-amount {
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.1) 0%, rgba(255, 193, 7, 0.1) 100%);
            border: 2px solid #dc3545;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
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
                
                <!-- Detail Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav class="breadcrumb mb-4">
                        <a class="breadcrumb-item text-decoration-none" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-house me-1"></i>Dashboard
                        </a>
                        <a class="breadcrumb-item text-decoration-none" href="${pageContext.request.contextPath}/admin/additional-costs">
                            Chi phí phát sinh
                        </a>
                        <span class="breadcrumb-item active">Chi tiết #${additionalCost.costId}</span>
                    </nav>
                    
                    <!-- Main Detail -->
                    <div class="row">
                        <div class="col-lg-8">
                            <!-- Cost Header -->
                            <div class="detail-header">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="d-flex align-items-center mb-2">
                                            <i class="bi bi-receipt-cutoff text-primary me-2 fs-3"></i>
                                            <div>
                                                <h4 class="mb-0">Chi phí phát sinh #${additionalCost.costId}</h4>
                                                <div class="text-muted">
                                                    <small>
                                                        <i class="bi bi-calendar me-1"></i>
                                                        Ngày tạo: <fmt:formatDate value="${additionalCost.date}" pattern="dd/MM/yyyy"/>
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="highlight-amount mt-3">
                                            <div class="cost-amount">
                                                <fmt:formatNumber value="${additionalCost.amount}" 
                                                                type="currency" 
                                                                currencySymbol="₫" 
                                                                groupingUsed="true"/>
                                            </div>
                                            <small class="text-muted">Tổng chi phí phát sinh</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Tenant Information -->
                            <div class="detail-card">
                                <div class="detail-section">
                                    <h5 class="section-title">
                                        <i class="bi bi-person-check me-2"></i>
                                        Thông tin Khách thuê
                                    </h5>
                                    
                                    <div class="row">
                                        <div class="col-auto">
                                            <div class="tenant-avatar">
                                                ${additionalCost.tenantName.substring(0, 1).toUpperCase()}
                                            </div>
                                        </div>
                                        <div class="col">
                                            <div class="info-item">
                                                <div class="info-label">Tên khách thuê</div>
                                                <div class="info-value h5">${additionalCost.tenantName}</div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">Phòng đang thuê</div>
                                                <div class="info-value h6 text-primary">
                                                    <i class="bi bi-door-open me-1"></i>
                                                    ${additionalCost.roomName}
                                                </div>
                                            </div>
                                            <div class="info-item">
                                                <div class="info-label">ID Khách thuê</div>
                                                <div class="info-value">
                                                    <span class="badge bg-secondary">#${additionalCost.tenantId}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Cost Details -->
                            <div class="detail-card">
                                <div class="detail-section">
                                    <h5 class="section-title">
                                        <i class="bi bi-file-text me-2"></i>
                                        Chi tiết Chi phí
                                    </h5>
                                    
                                    <div class="row">
                                        <div class="col-md-12 mb-3">
                                            <div class="info-item">
                                                <div class="info-label">Mô tả chi phí</div>
                                                <div class="info-value">
                                                    <p class="mb-0" style="white-space: pre-line;">${additionalCost.description}</p>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6 mb-3">
                                            <div class="info-item">
                                                <div class="info-label">Số tiền</div>
                                                <div class="info-value h4 text-danger">
                                                    <fmt:formatNumber value="${additionalCost.amount}" 
                                                                    type="currency" 
                                                                    currencySymbol="₫" 
                                                                    groupingUsed="true"/>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-6 mb-3">
                                            <div class="info-item">
                                                <div class="info-label">Ngày phát sinh</div>
                                                <div class="info-value h6">
                                                    <i class="bi bi-calendar-event text-warning me-1"></i>
                                                    <fmt:formatDate value="${additionalCost.date}" pattern="EEEE, dd/MM/yyyy"/>
                                                </div>
                                                <div class="text-muted">
                                                    <small>
                                                        Tháng/Năm: <fmt:formatDate value="${additionalCost.date}" pattern="MM/yyyy"/>
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Timeline Information -->
                            <div class="detail-card">
                                <div class="detail-section">
                                    <h5 class="section-title">
                                        <i class="bi bi-clock-history me-2"></i>
                                        Thông tin Hệ thống
                                    </h5>
                                    
                                    <div class="cost-timeline">
                                        <div class="timeline-item">
                                            <div class="info-item">
                                                <div class="info-label">Mã chi phí</div>
                                                <div class="info-value">
                                                    <span class="badge bg-primary">#${additionalCost.costId}</span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="timeline-item">
                                            <div class="info-item">
                                                <div class="info-label">Trạng thái</div>
                                                <div class="info-value">
                                                    <span class="badge bg-success status-badge">
                                                        <i class="bi bi-check-circle me-1"></i>
                                                        Đã ghi nhận
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="timeline-item">
                                            <div class="info-item">
                                                <div class="info-label">Áp dụng cho hóa đơn</div>
                                                <div class="info-value">
                                                    <div class="text-info">
                                                        <i class="bi bi-receipt me-1"></i>
                                                        Hóa đơn tháng <fmt:formatDate value="${additionalCost.date}" pattern="MM/yyyy"/>
                                                    </div>
                                                    <small class="text-muted">Chi phí này sẽ được tính vào hóa đơn của tháng tương ứng</small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Sidebar -->
                        <div class="col-lg-4">
                            <div class="action-buttons">
                                <div class="detail-card">
                                    <h5 class="section-title">
                                        <i class="bi bi-gear me-2"></i>
                                        Thao tác
                                    </h5>
                                    
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/admin/additional-costs/edit/${additionalCost.costId}" 
                                           class="btn btn-primary">
                                            <i class="bi bi-pencil me-2"></i>
                                            Chỉnh sửa chi phí
                                        </a>
                                        
                                        <button type="button" 
                                                class="btn btn-outline-danger"
                                                onclick="confirmDelete()">
                                            <i class="bi bi-trash me-2"></i>
                                            Xóa chi phí
                                        </button>
                                        
                                        <hr>
                                        
                                        <a href="${pageContext.request.contextPath}/admin/additional-costs" 
                                           class="btn btn-secondary">
                                            <i class="bi bi-arrow-left me-2"></i>
                                            Quay lại danh sách
                                        </a>
                                        
                                        <a href="${pageContext.request.contextPath}/admin/tenants/view/${additionalCost.tenantId}" 
                                           class="btn btn-outline-info">
                                            <i class="bi bi-person-lines-fill me-2"></i>
                                            Xem thông tin thuê trọ
                                        </a>
                                    </div>
                                </div>
                                
                                <!-- Quick Stats -->
                                <div class="detail-card">
                                    <h5 class="section-title">
                                        <i class="bi bi-info-circle me-2"></i>
                                        Thông tin thêm
                                    </h5>
                                    
                                    <div class="info-item text-center">
                                        <div class="info-label">Chi phí bằng chữ</div>
                                        <div class="info-value small">
                                            <!-- Simple number to text conversion would go here -->
                                            <c:set var="amountValue" value="${additionalCost.amount}"/>
                                            <c:choose>
                                                <c:when test="${amountValue < 1000000}">
                                                    <fmt:formatNumber value="${amountValue / 1000}" maxFractionDigits="0"/> nghìn đồng
                                                </c:when>
                                                <c:when test="${amountValue < 1000000000}">
                                                    <fmt:formatNumber value="${amountValue / 1000000}" maxFractionDigits="1"/> triệu đồng
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${amountValue / 1000000000}" maxFractionDigits="1"/> tỷ đồng
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    
                                    <div class="info-item text-center">
                                        <div class="info-label">Độ dài mô tả</div>
                                        <div class="info-value">
                                            <span class="badge bg-info">${additionalCost.description.length()}/255 ký tự</span>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Warning Note -->
                                <div class="alert alert-warning">
                                    <i class="bi bi-exclamation-triangle me-2"></i>
                                    <strong>Lưu ý:</strong>
                                    <ul class="mb-0 mt-2">
                                        <li>Chi phí này đã được ghi nhận vào hệ thống</li>
                                        <li>Việc xóa sẽ không thể hoàn tác</li>
                                        <li>Hãy cân nhắc kỹ trước khi thay đổi</li>
                                    </ul>
                                </div>
                            </div>
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
                        Xác nhận xóa chi phí
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa chi phí phát sinh này không?</p>
                    
                    <div class="alert alert-danger">
                        <strong>Chi phí sẽ bị xóa:</strong><br>
                        <strong>Mã:</strong> #${additionalCost.costId}<br>
                        <strong>Khách thuê:</strong> ${additionalCost.tenantName}<br>
                        <strong>Số tiền:</strong> <fmt:formatNumber value="${additionalCost.amount}" 
                                                                   type="currency" 
                                                                   currencySymbol="₫" 
                                                                   groupingUsed="true"/><br>
                        <strong>Mô tả:</strong> ${additionalCost.description}
                    </div>
                    
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        <strong>Cảnh báo:</strong> Thao tác này không thể hoàn tác!
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="bi bi-x-circle me-1"></i>
                        Hủy bỏ
                    </button>
                    <form method="POST" action="${pageContext.request.contextPath}/admin/additional-costs/delete/${additionalCost.costId}" style="display: inline;">
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
        function confirmDelete() {
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
        
        // Print functionality
        function printDetail() {
            window.print();
        }
        
        // Add print styles
        const printStyles = `
            @media print {
                .sidebar, .navbar, .action-buttons, .breadcrumb {
                    display: none !important;
                }
                .main-content {
                    margin-left: 0 !important;
                }
                .col-lg-8 {
                    width: 100% !important;
                }
                .detail-card {
                    break-inside: avoid;
                    box-shadow: none !important;
                    border: 1px solid #dee2e6 !important;
                }
            }
        `;
        
        const styleSheet = document.createElement("style");
        styleSheet.type = "text/css";
        styleSheet.innerText = printStyles;
        document.head.appendChild(styleSheet);
    </script>
</body>
</html>
