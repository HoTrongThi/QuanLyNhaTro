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
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
        }
        
        .badge-available {
            background: #28a745;
        }
        
        .badge-occupied {
            background: #dc3545;
        }
        
        .table th {
            border: none;
            background: #f8f9fa;
            font-weight: 600;
        }
        
        /* Filter styles */
        #statusFilter {
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.9);
            transition: all 0.3s ease;
        }
        
        #statusFilter:focus {
            border-color: rgba(255, 255, 255, 0.8);
            box-shadow: 0 0 0 0.2rem rgba(255, 255, 255, 0.25);
            background: white;
        }
        
        .filter-info {
            border-left: 4px solid #0dcaf0;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .table tbody tr {
            transition: all 0.3s ease;
        }
        
        .table tbody tr[style*="display: none"] {
            opacity: 0;
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/rooms">
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
                
                <!-- Room Management Content -->
                <div class="p-4">
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
                    
                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <!-- Tổng phòng -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <i class="bi bi-building fs-1 mb-2"></i>
                                    <h3>${totalRooms}</h3>
                                    <p class="mb-0">Tổng Phòng</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Phòng trống -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-door-open fs-1 mb-2"></i>
                                    <h3>${availableRooms}</h3>
                                    <p class="mb-0">Phòng trống</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Đang thuê -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-person-fill fs-1 mb-2"></i>
                                    <h3>${occupiedRooms}</h3>
                                    <p class="mb-0">Đang thuê</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Đã đặt cọc -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-bookmark-fill fs-1 mb-2"></i>
                                    <h3>${reservedRooms}</h3>
                                    <p class="mb-0">Đã đặt cọc</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Thống kê trạng thái khác -->
                    <div class="row mb-4">
                        <!-- Đang sửa chữa -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-tools fs-1 mb-2"></i>
                                    <h3>${maintenanceRooms}</h3>
                                    <p class="mb-0">Đang sửa chữa</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Đang dọn dẹp -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-light text-dark">
                                <div class="card-body text-center">
                                    <i class="bi bi-brush fs-1 mb-2"></i>
                                    <h3>${cleaningRooms}</h3>
                                    <p class="mb-0">Đang dọn dẹp</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Ngưng sử dụng -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-secondary text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-pause-circle fs-1 mb-2"></i>
                                    <h3>${suspendedRooms}</h3>
                                    <p class="mb-0">Ngưng sử dụng</p>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Hết hạn hợp đồng -->
                        <div class="col-lg-3 col-md-6 mb-3">
                            <div class="card bg-danger text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-calendar-x fs-1 mb-2"></i>
                                    <h3>${contractExpiredRooms}</h3>
                                    <p class="mb-0">Hết hạn HĐ</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Room List -->
                    <div class="card">
                        <div class="card-header">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="mb-0">
                                        <i class="bi bi-list me-2"></i>
                                        Danh sách Phòng trọ
                                    </h5>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex justify-content-end align-items-center gap-2">
                                        <!-- Bộ lọc trạng thái -->
                                        <div class="d-flex align-items-center">
                                            <label for="statusFilter" class="form-label me-2 mb-0 text-white">
                                                <i class="bi bi-funnel me-1"></i>
                                                Lọc:
                                            </label>
                                            <select class="form-select form-select-sm" id="statusFilter" style="min-width: 150px;">
                                                <option value="">Tất cả trạng thái</option>
                                                <option value="AVAILABLE">🚪 Phòng trống</option>
                                                <option value="OCCUPIED">👤 Đang thuê</option>
                                                <option value="MAINTENANCE">🔧 Đang sửa chữa</option>
                                                <option value="RESERVED">🔖 Đã đặt cọc</option>
                                                <option value="SUSPENDED">⏸️ Ngưng sử dụng</option>
                                                <option value="CLEANING">🧹 Đang dọn dẹp</option>
                                                <option value="CONTRACT_EXPIRED">📅❌ Hết hạn HĐ</option>
                                            </select>
                                        </div>
                                        
                                        <!-- Nút thêm phòng -->
                                        <a href="${pageContext.request.contextPath}/admin/rooms/add" 
                                           class="btn btn-light btn-sm">
                                            <i class="bi bi-plus-circle me-1"></i>
                                            Thêm Phòng mới
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty rooms}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-house-slash fs-1 text-muted mb-3"></i>
                                        <h5 class="text-muted">Chưa có phòng nào</h5>
                                        <p class="text-muted">Hãy thêm phòng trọ đầu tiên của bạn</p>
                                        <a href="${pageContext.request.contextPath}/admin/rooms/add" 
                                           class="btn btn-primary">
                                            <i class="bi bi-plus-circle me-1"></i>
                                            Thêm Phòng mới
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Tên Phòng</th>
                                                    <th>Giá</th>
                                                    <th>Trạng thái</th>
                                                    <th>Mô tả</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="room" items="${rooms}">
                                                    <tr>
                                                        <td>
                                                            <strong>${room.roomName}</strong>
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${room.price}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${room.statusBadgeClass}">
                                                                <i class="bi ${room.statusIcon} me-1"></i>
                                                                ${room.statusDisplayName}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty room.description}">
                                                                    <c:choose>
                                                                        <c:when test="${room.description.length() > 50}">
                                                                            ${room.description.substring(0, 50)}...
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${room.description}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Không có mô tả</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/admin/rooms/view/${room.roomId}" 
                                                                   class="btn btn-outline-info btn-sm" 
                                                                   title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/admin/rooms/edit/${room.roomId}" 
                                                                   class="btn btn-outline-primary btn-sm" 
                                                                   title="Chỉnh sửa">
                                                                    <i class="bi bi-pencil"></i>
                                                                </a>
                                                                <!-- Check if room can be deleted -->
                                                                <c:choose>
                                                                    <c:when test="${room.status == 'AVAILABLE'}">
                                                                        <button type="button" 
                                                                                class="btn btn-outline-danger btn-sm" 
                                                                                title="Xóa"
                                                                                onclick="confirmDelete(${room.roomId}, '${room.roomName}')">
                                                                            <i class="bi bi-trash"></i>
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <button type="button" 
                                                                                class="btn btn-outline-secondary btn-sm" 
                                                                                title="Không thể xóa - Phòng không ở trạng thái trống"
                                                                                disabled>
                                                                            <i class="bi bi-trash"></i>
                                                                        </button>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
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
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa phòng <strong id="roomNameToDelete"></strong>?</p>
                    <p class="text-warning">
                        <i class="bi bi-exclamation-triangle me-1"></i>
                        Hành động này không thể hoàn tác!
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <form id="deleteForm" method="POST" action="" style="display: inline;">
                        <input type="hidden" name="_method" value="POST">
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(roomId, roomName) {
            // Set room name in modal
            document.getElementById('roomNameToDelete').textContent = roomName;
            
            // Set form action with correct URL
            var deleteForm = document.getElementById('deleteForm');
            deleteForm.action = '${pageContext.request.contextPath}/admin/rooms/delete/' + roomId;
            
            // Show modal
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
        
        // Add form submit handler to ensure proper submission
        document.addEventListener('DOMContentLoaded', function() {
            var deleteForm = document.getElementById('deleteForm');
            if (deleteForm) {
                deleteForm.addEventListener('submit', function(e) {
                    // Ensure form has action before submitting
                    if (!this.action || this.action.endsWith('/admin/rooms/delete/')) {
                        e.preventDefault();
                        alert('Lỗi: Không thể xác định phòng cần xóa. Vui lòng thử lại.');
                        return false;
                    }
                    
                    // Form is valid, allow submission
                    return true;
                });
            }
            
            // Status filter functionality
            var statusFilter = document.getElementById('statusFilter');
            if (statusFilter) {
                statusFilter.addEventListener('change', function() {
                    filterRoomsByStatus(this.value);
                });
                
                // Check for filter parameter in URL
                var urlParams = new URLSearchParams(window.location.search);
                var filterParam = urlParams.get('filter');
                if (filterParam) {
                    statusFilter.value = filterParam;
                    filterRoomsByStatus(filterParam);
                    
                    // Show notification that filter was applied from dashboard
                    showDashboardFilterNotification(filterParam);
                }
            }
        });
        
        // Function to filter rooms by status
        function filterRoomsByStatus(selectedStatus) {
            var tableRows = document.querySelectorAll('tbody tr');
            var visibleCount = 0;
            
            tableRows.forEach(function(row) {
                var statusBadge = row.querySelector('.badge');
                if (!statusBadge) return;
                
                // Get room status from badge classes
                var roomStatus = '';
                if (statusBadge.classList.contains('bg-success')) {
                    roomStatus = 'AVAILABLE';
                } else if (statusBadge.classList.contains('bg-primary')) {
                    roomStatus = 'OCCUPIED';
                } else if (statusBadge.classList.contains('bg-warning')) {
                    roomStatus = 'MAINTENANCE';
                } else if (statusBadge.classList.contains('bg-info')) {
                    roomStatus = 'RESERVED';
                } else if (statusBadge.classList.contains('bg-secondary')) {
                    roomStatus = 'SUSPENDED';
                } else if (statusBadge.classList.contains('bg-light')) {
                    roomStatus = 'CLEANING';
                } else if (statusBadge.classList.contains('bg-danger')) {
                    roomStatus = 'CONTRACT_EXPIRED';
                }
                
                // Show/hide row based on filter
                if (selectedStatus === '' || roomStatus === selectedStatus) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });
            
            // Update filter result info
            updateFilterInfo(selectedStatus, visibleCount, tableRows.length);
        }
        
        // Function to update filter information
        function updateFilterInfo(selectedStatus, visibleCount, totalCount) {
            // Remove existing filter info
            var existingInfo = document.querySelector('.filter-info');
            if (existingInfo) {
                existingInfo.remove();
            }
            
            // Add new filter info if filtering is active
            if (selectedStatus !== '') {
                var tableContainer = document.querySelector('.table-responsive');
                if (tableContainer) {
                    var filterInfo = document.createElement('div');
                    filterInfo.className = 'filter-info alert alert-info mt-2 mb-0';
                    
                    var statusNames = {
                        'AVAILABLE': 'Phòng trống',
                        'OCCUPIED': 'Đang thuê',
                        'MAINTENANCE': 'Đang sửa chữa',
                        'RESERVED': 'Đã đặt cọc',
                        'SUSPENDED': 'Ngưng sử dụng',
                        'CLEANING': 'Đang dọn dẹp',
                        'CONTRACT_EXPIRED': 'Hết hạn hợp đồng'
                    };
                    
                    filterInfo.innerHTML = '<i class="bi bi-info-circle me-2"></i>' +
                        'Hiển thị <strong>' + visibleCount + '</strong> phòng có trạng thái "<strong>' + 
                        statusNames[selectedStatus] + '</strong>" trên tổng số <strong>' + totalCount + '</strong> phòng. ' +
                        '<a href="#" onclick="clearFilter()" class="alert-link">Xóa bộ lọc</a>';
                    
                    tableContainer.appendChild(filterInfo);
                }
            }
        }
        
        // Function to clear filter
        function clearFilter() {
            var statusFilter = document.getElementById('statusFilter');
            if (statusFilter) {
                statusFilter.value = '';
                filterRoomsByStatus('');
            }
        }
        
        // Function to show dashboard filter notification
        function showDashboardFilterNotification(filterValue) {
            var statusNames = {
                'AVAILABLE': 'Phòng trống',
                'OCCUPIED': 'Đang thuê',
                'MAINTENANCE': 'Đang sửa chữa',
                'RESERVED': 'Đã đặt cọc',
                'SUSPENDED': 'Ngưng sử dụng',
                'CLEANING': 'Đang dọn dẹp',
                'CONTRACT_EXPIRED': 'Hết hạn hợp đồng'
            };
            
            // Create notification element
            var notification = document.createElement('div');
            notification.className = 'alert alert-success alert-dismissible fade show dashboard-notification';
            notification.innerHTML = '<i class="bi bi-speedometer2 me-2"></i>' +
                '<strong>Từ Bảng điều khiển:</strong> Đã lọc hiển thị phòng có trạng thái "<strong>' + 
                statusNames[filterValue] + '</strong>". ' +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            // Insert notification after success/error messages
            var mainContent = document.querySelector('.p-4');
            var firstCard = mainContent.querySelector('.row');
            if (firstCard) {
                mainContent.insertBefore(notification, firstCard);
            }
            
            // Auto-hide after 5 seconds
            setTimeout(function() {
                if (notification && notification.parentNode) {
                    notification.classList.remove('show');
                    setTimeout(function() {
                        if (notification && notification.parentNode) {
                            notification.remove();
                        }
                    }, 150);
                }
            }, 5000);
        }
    </script>
</body>
</html>
