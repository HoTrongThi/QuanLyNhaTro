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
        
        .table-hover tbody tr:hover {
            background-color: rgba(102, 126, 234, 0.1);
        }
        
        .badge-paid {
            background: linear-gradient(135deg, #28a745, #20c997);
        }
        
        .badge-unpaid {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
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
        
        /* Room Card Styles for Bills */
        .bill-room-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            margin-bottom: 20px;
            overflow: hidden;
            cursor: pointer;
        }
        
        .bill-room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .bill-room-card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 15px 15px 0 0;
        }
        
        .bill-room-card-header.has-debt {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
        }
        
        .bill-room-card-header.no-debt {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .bill-room-card-header.no-tenants {
            background: linear-gradient(135deg, #6c757d 0%, #adb5bd 100%);
        }
        
        .bill-room-name {
            font-size: 1.4em;
            font-weight: bold;
            margin: 0;
        }
        
        .bill-debt-status {
            font-size: 0.9em;
            opacity: 0.9;
            margin: 0;
        }
        
        .bill-room-card-body {
            padding: 20px;
        }
        
        .bill-tenants-list {
            margin-bottom: 15px;
        }
        
        .bill-tenant-item {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 8px 12px;
            margin-bottom: 6px;
            border-left: 4px solid #667eea;
            font-size: 0.9em;
        }
        
        .bill-debt-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 15px;
        }
        
        .bill-debt-info.no-debt {
            background: #d1edff;
            border-color: #bee5eb;
        }
        
        .bill-debt-info.no-tenants {
            background: #f8f9fa;
            border-color: #dee2e6;
        }
        
        .debt-amount {
            font-size: 1.1em;
            font-weight: bold;
            color: #dc3545;
        }
        
        .debt-amount.no-debt {
            color: #28a745;
        }
        
        .debt-periods {
            font-size: 0.85em;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .bill-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .bill-actions .btn {
            flex: 1;
            min-width: 120px;
            font-weight: 600;
        }
        
        .bill-actions .btn.w-100 {
            min-width: 100%;
        }
        
        .empty-bills {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }
        
        .empty-bills i {
            font-size: 3em;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        
        /* Bills Modal */
        .bills-modal .modal-dialog {
            max-width: 90%;
        }
        
        .bills-table {
            font-size: 0.9em;
        }
        
        .bills-table th {
            background: #f8f9fa;
            font-weight: 600;
            border-top: none;
        }
        
        .modal-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
                
                <!-- Bills Content -->
                <div class="p-4">
                
                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card p-3" style="background: linear-gradient(135deg, #dc3545, #fd7e14); color: white;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">Phòng đang nợ</h6>
                                    <h3 class="mb-0">${roomsWithDebt}</h3>
                                </div>
                                <i class="bi bi-exclamation-triangle fs-1 opacity-75"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card p-3" style="background: linear-gradient(135deg, #fd7e14, #ffc107); color: white;">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <h6 class="mb-1">Số hóa đơn đang nợ</h6>
                                    <h3 class="mb-0">${totalUnpaidInvoices}</h3>
                                </div>
                                <i class="bi bi-receipt fs-1 opacity-75"></i>
                            </div>
                        </div>
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
                
                <!-- Room Cards for Bills -->
                <!-- Room Cards for Bills -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="text-muted mb-0">
                        <i class="bi bi-grid-3x3-gap me-2"></i>
                        Quản lý Hóa đơn theo Phòng
                    </h5>
                    <a href="${pageContext.request.contextPath}/admin/bills/generate" class="btn btn-custom">
                        <i class="bi bi-plus-lg me-2"></i>Tạo hóa đơn
                    </a>
                </div>
                
                <c:choose>
                    <c:when test="${not empty rooms}">
                        <div class="row">
                            <c:forEach var="room" items="${rooms}" varStatus="status">
                                <div class="col-lg-4 col-md-6 mb-4">
                                    <div class="bill-room-card" onclick="showRoomBills('${room.roomId}', '${room.roomName}')">
                                        <!-- Room Header -->
                                        <div class="bill-room-card-header 
                                            <c:choose>
                                                <c:when test="${room.hasUnpaidBills}">
                                                    has-debt
                                                </c:when>
                                                <c:when test="${room.hasActiveTenants}">
                                                    no-debt
                                                </c:when>
                                                <c:otherwise>
                                                    no-tenants
                                                </c:otherwise>
                                            </c:choose>">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h5 class="bill-room-name">
                                                        <i class="bi bi-door-open me-2"></i>
                                                        ${room.roomName}
                                                    </h5>
                                                    <p class="bill-debt-status">
                                                        <c:choose>
                                                            <c:when test="${room.hasUnpaidBills}">
                                                                <i class="bi bi-exclamation-triangle me-1"></i>
                                                                Có hóa đơn chưa thanh toán
                                                            </c:when>
                                                            <c:when test="${room.hasActiveTenants}">
                                                                <i class="bi bi-check-circle me-1"></i>
                                                                Hóa đơn đã thanh toán
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="bi bi-house me-1"></i>
                                                                Phòng trống
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <div class="text-end">
                                                    <c:choose>
                                                        <c:when test="${room.hasUnpaidBills}">
                                                            <span class="badge bg-light text-dark">
                                                                ${room.unpaidCount} hóa đơn
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${room.hasActiveTenants}">
                                                            <span class="badge bg-light text-dark">
                                                                ${room.tenantCount} người
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-light text-dark">
                                                                Trống
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Room Body -->
                                        <div class="bill-room-card-body">
                                            <!-- Tenants List -->
                                            <c:choose>
                                                <c:when test="${not empty room.tenants}">
                                                    <div class="bill-tenants-list">
                                                        <h6 class="text-muted mb-2">
                                                            <i class="bi bi-people me-1"></i>
                                                            Khách thuê hiện tại:
                                                        </h6>
                                                        <c:forEach var="tenant" items="${room.tenants}">
                                                            <div class="bill-tenant-item">
                                                                <strong>${tenant.fullName}</strong>
                                                                <c:if test="${not empty tenant.phone}">
                                                                    <br><small class="text-muted">
                                                                        <i class="bi bi-telephone me-1"></i>
                                                                        ${tenant.phone}
                                                                    </small>
                                                                </c:if>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="empty-bills">
                                                        <i class="bi bi-house"></i>
                                                        <p class="mb-0">Phòng trống</p>
                                                        <small>Không có khách thuê</small>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <!-- Debt Information -->
                                            <c:if test="${room.hasActiveTenants}">
                                                <div class="bill-debt-info 
                                                    <c:choose>
                                                        <c:when test="${room.hasUnpaidBills}">
                                                            
                                                        </c:when>
                                                        <c:otherwise>
                                                            no-debt
                                                        </c:otherwise>
                                                    </c:choose>">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div>
                                                            <strong>
                                                                <c:choose>
                                                                    <c:when test="${room.hasUnpaidBills}">
                                                                        <i class="bi bi-exclamation-triangle text-warning me-1"></i>
                                                                        Tổng nợ:
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="bi bi-check-circle text-success me-1"></i>
                                                                        Trạng thái:
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </strong>
                                                        </div>
                                                        <div class="debt-amount 
                                                            <c:if test="${!room.hasUnpaidBills}">no-debt</c:if>">
                                                            <c:choose>
                                                                <c:when test="${room.hasUnpaidBills}">
                                                                    <fmt:formatNumber value="${room.totalDebt}" 
                                                                                    type="currency" 
                                                                                    currencySymbol="₫" 
                                                                                    groupingUsed="true"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Đã thanh toán
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                    <c:if test="${room.hasUnpaidBills}">
                                                        <div class="debt-periods">
                                                            <i class="bi bi-calendar me-1"></i>
                                                            Kỳ nợ: ${room.unpaidPeriods}
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:if>
                                            
                                            <!-- Room Actions -->
                                            <div class="bill-actions">
                                                <button type="button" 
                                                        class="btn btn-primary btn-sm w-100" 
                                                        onclick="event.stopPropagation(); showRoomBills('${room.roomId}', '${room.roomName}')">
                                                    <i class="bi bi-receipt me-1"></i>
                                                    Xem hóa đơn chưa thanh toán
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-bills">
                            <i class="bi bi-receipt"></i>
                            <h5 class="text-muted mt-3">Chưa có hóa đơn nào trong hệ thống</h5>
                            <p class="text-muted">Tạo hóa đơn ngay</p>
                            <a href="${pageContext.request.contextPath}/admin/bills/generate" class="btn btn-primary">
                                <i class="bi bi-plus-circle me-1"></i>
                                Tạo hóa đơn
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Room Bills Modal -->
    <div class="modal fade bills-modal" id="roomBillsModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header modal-header-custom">
                    <h5 class="modal-title">
                        <i class="bi bi-receipt me-2"></i>
                        Hóa đơn phòng <span id="modalRoomName"></span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <div id="billsTableContainer">
                        <!-- Bills table will be loaded here -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p><i class="bi bi-exclamation-triangle text-warning fs-3"></i></p>
                    <p>Bạn có chắc chắn muốn xóa hóa đơn này?</p>
                    <p class="text-muted"><strong>Lưu ý:</strong> Thao tác này không thể hoàn tác!</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form method="POST" style="display: inline;" id="deleteForm">
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-trash me-2"></i>Xóa
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentRoomId = null;
        let currentRoomName = null;
        
        function showRoomBills(roomId, roomName) {
            currentRoomId = roomId;
            currentRoomName = roomName;
            
            // Update modal title
            document.getElementById('modalRoomName').textContent = roomName;
            
            // Load bills for this room
            fetch('${pageContext.request.contextPath}/admin/bills/room/' + roomId)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('billsTableContainer').innerHTML = html;
                })
                .catch(error => {
                    console.error('Error loading bills:', error);
                    document.getElementById('billsTableContainer').innerHTML = 
                        '<div class="text-center p-4"><div class="text-danger">Lỗi tải dữ liệu hóa đơn</div></div>';
                });
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('roomBillsModal'));
            modal.show();
        }
        
        function showBillDetail(invoiceId) {
            // Update modal title to show we're viewing detail
            document.getElementById('modalRoomName').textContent = currentRoomName + ' - Chi tiết hóa đơn #' + invoiceId;
            
            // Load bill detail
            fetch('${pageContext.request.contextPath}/admin/bills/view/' + invoiceId)
                .then(response => response.text())
                .then(html => {
                    // Extract only the main content part, excluding sidebar
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    
                    // Find the main content column (col-md-9 col-lg-10 main-content)
                    const mainContentColumn = doc.querySelector('.col-md-9.col-lg-10.main-content') || 
                                            doc.querySelector('.col-md-9.main-content') || 
                                            doc.querySelector('.col-lg-10.main-content') || 
                                            doc.querySelector('.main-content');
                    
                    if (mainContentColumn) {
                        // Create back button
                        const backButton = document.createElement('div');
                        backButton.className = 'mb-3';
                        backButton.innerHTML = '<button type="button" class="btn btn-outline-secondary" onclick="showBillsList()"><i class="bi bi-arrow-left me-1"></i>Quay lại danh sách</button>';
                        
                        // Clone the main content and add back button
                        const contentClone = mainContentColumn.cloneNode(true);
                        
                        // Remove any existing header/navigation that we don't need in modal
                        const header = contentClone.querySelector('.d-flex.justify-content-between.align-items-center');
                        if (header) {
                            header.remove();
                        }
                        
                        // Insert back button at the beginning
                        contentClone.insertBefore(backButton, contentClone.firstChild);
                        
                        // Set the content
                        document.getElementById('billsTableContainer').innerHTML = contentClone.innerHTML;
                    } else {
                        // Fallback: try to get just the invoice detail content
                        const invoiceDetail = doc.querySelector('.row');
                        if (invoiceDetail) {
                            const backButton = document.createElement('div');
                            backButton.className = 'mb-3';
                            backButton.innerHTML = '<button type="button" class="btn btn-outline-secondary" onclick="showBillsList()"><i class="bi bi-arrow-left me-1"></i>Quay lại danh sách</button>';
                            
                            const contentClone = invoiceDetail.cloneNode(true);
                            contentClone.insertBefore(backButton, contentClone.firstChild);
                            
                            document.getElementById('billsTableContainer').innerHTML = contentClone.innerHTML;
                        } else {
                            document.getElementById('billsTableContainer').innerHTML = 
                                '<div class="text-center p-4"><div class="text-danger">Không thể tải chi tiết hóa đơn</div></div>';
                        }
                    }
                })
                .catch(error => {
                    console.error('Error loading bill detail:', error);
                    document.getElementById('billsTableContainer').innerHTML = 
                        '<div class="text-center p-4"><div class="text-danger">Lỗi tải chi tiết hóa đơn</div></div>';
                });
        }
        
        function showBillsList() {
            // Go back to bills list
            showRoomBills(currentRoomId, currentRoomName);
        }
        
        function confirmDelete(invoiceId) {
            const form = document.getElementById('deleteForm');
            form.action = '${pageContext.request.contextPath}/admin/bills/delete/' + invoiceId;
            
            const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }
    </script>
</body>
</html>
