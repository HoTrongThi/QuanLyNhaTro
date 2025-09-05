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
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
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
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .super-admin-badge {
            background: linear-gradient(135deg, #dc3545 0%, #6f42c1 100%);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: bold;
        }
        
        .log-item {
            border-left: 4px solid #dee2e6;
            transition: all 0.3s ease;
        }
        
        .log-item:hover {
            background-color: #f8f9fa;
            border-left-color: #007bff;
        }
        
        .log-item.critical {
            border-left-color: #dc3545;
            background-color: rgba(220, 53, 69, 0.05);
        }
        
        .log-item.create { border-left-color: #28a745; }
        .log-item.update { border-left-color: #17a2b8; }
        .log-item.delete { border-left-color: #dc3545; }
        .log-item.reset { border-left-color: #ffc107; }
        .log-item.suspend { border-left-color: #fd7e14; }
        .log-item.activate { border-left-color: #20c997; }
        
        .timeline {
            position: relative;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 30px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #dee2e6;
        }
        
        .timeline-item {
            position: relative;
            padding-left: 70px;
            margin-bottom: 30px;
        }
        
        .timeline-marker {
            position: absolute;
            left: 20px;
            top: 10px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: white;
            border: 3px solid #dee2e6;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .timeline-marker.critical { border-color: #dc3545; color: #dc3545; }
        .timeline-marker.create { border-color: #28a745; color: #28a745; }
        .timeline-marker.update { border-color: #17a2b8; color: #17a2b8; }
        .timeline-marker.delete { border-color: #dc3545; color: #dc3545; }
        .timeline-marker.reset { border-color: #ffc107; color: #ffc107; }
        .timeline-marker.suspend { border-color: #fd7e14; color: #fd7e14; }
        .timeline-marker.activate { border-color: #20c997; color: #20c997; }
        
        .filter-chip {
            display: inline-block;
            padding: 4px 12px;
            margin: 2px;
            background: #e9ecef;
            border-radius: 20px;
            font-size: 0.875rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .filter-chip:hover {
            background: #007bff;
            color: white;
        }
        
        .filter-chip.active {
            background: #007bff;
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
                        <i class="bi bi-shield-fill-exclamation me-2"></i>
                        Super Admin
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-shield-fill-exclamation fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <span class="super-admin-badge">SUPER ADMIN</span>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/super-admin/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/super-admin/admins">
                            <i class="bi bi-person-gear me-2"></i>
                            Quản lý Admin
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/super-admin/audit-logs">
                            <i class="bi bi-journal-text me-2"></i>
                            Nhật ký hoạt động
                        </a>
                        <hr class="text-light">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-arrow-left-circle me-2"></i>
                            Chế độ Admin
                        </a>
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
                        <h5 class="navbar-brand mb-0">
                            <i class="bi bi-journal-text text-info me-2"></i>
                            ${pageTitle}
                        </h5>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-shield-fill-exclamation me-1 text-danger"></i>
                                    ${user.fullName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Thông tin cá nhân</a></li>
                                    <li><a class="dropdown-item" href="#">Cài đặt hệ thống</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">Chế độ Admin</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
                
                <!-- Content -->
                <div class="p-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h4 class="mb-1">Nhật ký hoạt động</h4>
                            <p class="text-muted mb-0">Theo dõi tất cả hoạt động của Super Admin trong hệ thống</p>
                        </div>
                        <div class="d-flex align-items-center">
                            <span class="me-3">Hiển thị: ${limit} bản ghi</span>
                            <div class="btn-group">
                                <a href="?limit=25" class="btn btn-outline-secondary btn-sm ${limit == 25 ? 'active' : ''}">25</a>
                                <a href="?limit=50" class="btn btn-outline-secondary btn-sm ${limit == 50 ? 'active' : ''}">50</a>
                                <a href="?limit=100" class="btn btn-outline-secondary btn-sm ${limit == 100 ? 'active' : ''}">100</a>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Filter Chips -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <h6 class="card-title mb-3">
                                <i class="bi bi-funnel me-2"></i>
                                Lọc theo loại hoạt động
                            </h6>
                            <div id="filterChips">
                                <span class="filter-chip active" data-filter="all">
                                    <i class="bi bi-list me-1"></i>
                                    Tất cả
                                </span>
                                <span class="filter-chip" data-filter="create_admin">
                                    <i class="bi bi-person-plus me-1"></i>
                                    Tạo Admin
                                </span>
                                <span class="filter-chip" data-filter="update_admin">
                                    <i class="bi bi-pencil me-1"></i>
                                    Cập nhật Admin
                                </span>
                                <span class="filter-chip" data-filter="delete_admin">
                                    <i class="bi bi-person-dash me-1"></i>
                                    Xóa Admin
                                </span>
                                <span class="filter-chip" data-filter="reset_password">
                                    <i class="bi bi-key me-1"></i>
                                    Reset mật khẩu
                                </span>
                                <span class="filter-chip" data-filter="suspend_admin">
                                    <i class="bi bi-pause me-1"></i>
                                    Tạm khóa
                                </span>
                                <span class="filter-chip" data-filter="activate_admin">
                                    <i class="bi bi-play me-1"></i>
                                    Kích hoạt
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Audit Logs -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-clock-history me-2"></i>
                                Lịch sử hoạt động
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty auditLogs}">
                                    <div class="timeline">
                                        <c:forEach var="log" items="${auditLogs}">
                                            <div class="timeline-item log-entry" data-action="${log.action.toLowerCase()}">
                                                <div class="timeline-marker ${log.action.toLowerCase()} ${log.criticalAction ? 'critical' : ''}">
                                                    <i class="${log.actionIcon}" style="font-size: 10px;"></i>
                                                </div>
                                                
                                                <div class="card log-item ${log.action.toLowerCase()} ${log.criticalAction ? 'critical' : ''}">
                                                    <div class="card-body p-3">
                                                        <div class="row align-items-start">
                                                            <div class="col">
                                                                <!-- Action Header -->
                                                                <div class="d-flex align-items-center mb-2">
                                                                    <span class="badge ${log.actionBadgeClass} me-2">
                                                                        <i class="${log.actionIcon} me-1"></i>
                                                                        ${log.actionDisplayName}
                                                                    </span>
                                                                    <c:if test="${log.criticalAction}">
                                                                        <span class="badge bg-danger">
                                                                            <i class="bi bi-exclamation-triangle me-1"></i>
                                                                            Quan trọng
                                                                        </span>
                                                                    </c:if>
                                                                </div>
                                                                
                                                                <!-- Description -->
                                                                <p class="mb-2">${log.shortDescription}</p>
                                                                
                                                                <!-- Details -->
                                                                <div class="row text-sm">
                                                                    <div class="col-md-6">
                                                                        <small class="text-muted">
                                                                            <i class="bi bi-person me-1"></i>
                                                                            <strong>Thực hiện bởi:</strong> ${log.superAdminName}
                                                                        </small>
                                                                    </div>
                                                                    <c:if test="${log.hasTargetAdmin()}">
                                                                        <div class="col-md-6">
                                                                            <small class="text-muted">
                                                                                <i class="bi bi-bullseye me-1"></i>
                                                                                <strong>Đối tượng:</strong> ${log.targetAdminName}
                                                                            </small>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                                
                                                                <!-- Technical Details - Hidden for cleaner UI -->
                                                                <%-- 
                                                                <div class="row text-sm mt-2">
                                                                    <div class="col-md-4">
                                                                        <small class="text-muted">
                                                                            <i class="bi bi-globe me-1"></i>
                                                                            IP: ${log.ipAddress}
                                                                        </small>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <small class="text-muted">
                                                                            <i class="bi bi-browser-chrome me-1"></i>
                                                                            ${log.browserName}
                                                                        </small>
                                                                    </div>
                                                                    <div class="col-md-4">
                                                                        <small class="text-muted">
                                                                            <i class="bi bi-hash me-1"></i>
                                                                            ID: ${log.logId}
                                                                        </small>
                                                                    </div>
                                                                </div>
                                                                --%>
                                                            </div>
                                                            
                                                            <!-- Timestamp -->
                                                            <div class="col-auto text-end">
                                                                <div class="text-muted">
                                                                    <small>
                                                                        <i class="bi bi-clock me-1"></i>
                                                                        ${log.relativeTime}
                                                                    </small>
                                                                </div>
                                                                <div class="text-muted">
                                                                    <small>${log.formattedCreatedAt}</small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                        <!-- Expandable Details -->
                                                        <c:if test="${not empty log.details}">
                                                            <div class="mt-3">
                                                                <button class="btn btn-outline-secondary btn-sm" type="button" 
                                                                        data-bs-toggle="collapse" data-bs-target="#details-${log.logId}">
                                                                    <i class="bi bi-info-circle me-1"></i>
                                                                    Chi tiết kỹ thuật
                                                                </button>
                                                                <div class="collapse mt-2" id="details-${log.logId}">
                                                                    <div class="card bg-light">
                                                                        <div class="card-body p-2">
                                                                            <pre class="mb-0" style="font-size: 0.8rem;">${log.details}</pre>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    
                                    <!-- Load More -->
                                    <c:if test="${auditLogs.size() >= limit}">
                                        <div class="text-center mt-4">
                                            <a href="?limit=${limit + 25}" class="btn btn-outline-primary">
                                                <i class="bi bi-arrow-down me-2"></i>
                                                Tải thêm
                                            </a>
                                        </div>
                                    </c:if>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="bi bi-journal-text fs-1 text-muted mb-3"></i>
                                        <h5 class="text-muted">Chưa có hoạt động nào</h5>
                                        <p class="text-muted">Các hoạt động của Super Admin sẽ được ghi lại tại đây</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Filter functionality
        document.addEventListener('DOMContentLoaded', function() {
            const filterChips = document.querySelectorAll('.filter-chip');
            const logEntries = document.querySelectorAll('.log-entry');
            
            filterChips.forEach(chip => {
                chip.addEventListener('click', function() {
                    // Update active chip
                    filterChips.forEach(c => c.classList.remove('active'));
                    this.classList.add('active');
                    
                    const filter = this.dataset.filter;
                    
                    // Filter log entries
                    logEntries.forEach(entry => {
                        if (filter === 'all' || entry.dataset.action === filter) {
                            entry.style.display = 'block';
                        } else {
                            entry.style.display = 'none';
                        }
                    });
                });
            });
        });
        
        // Auto-refresh every 30 seconds
        setInterval(function() {
            // Only refresh if user is viewing "all" logs
            const activeFilter = document.querySelector('.filter-chip.active');
            if (activeFilter && activeFilter.dataset.filter === 'all') {
                // You can implement auto-refresh here if needed
                // location.reload();
            }
        }, 30000);
        
        // Smooth scroll to top
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }
        
        // Add scroll to top button if page is long
        window.addEventListener('scroll', function() {
            const scrollBtn = document.getElementById('scrollTopBtn');
            if (window.pageYOffset > 300) {
                if (!scrollBtn) {
                    const btn = document.createElement('button');
                    btn.id = 'scrollTopBtn';
                    btn.className = 'btn btn-primary position-fixed';
                    btn.style.cssText = 'bottom: 20px; right: 20px; z-index: 1000; border-radius: 50%; width: 50px; height: 50px;';
                    btn.innerHTML = '<i class="bi bi-arrow-up"></i>';
                    btn.onclick = scrollToTop;
                    document.body.appendChild(btn);
                }
            } else {
                const scrollBtn = document.getElementById('scrollTopBtn');
                if (scrollBtn) {
                    scrollBtn.remove();
                }
            }
        });
    </script>
</body>
</html>