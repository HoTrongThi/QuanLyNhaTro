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

        .message-item {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
            background: white;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .message-item:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .contact-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }
        
        .user-avatar {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .contact-name {
            font-weight: 600;
            color: #333;
        }
        
        .role-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 12px;
            color: white;
            background: #28a745;
        }

        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
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
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Quản lý Hóa đơn
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/admin/messages">
                            <i class="bi bi-chat-dots me-2"></i>
                            Tin nhắn
                            <c:if test="${unreadCount > 0}">
                                <span class="badge bg-danger ms-2">${unreadCount}</span>
                            </c:if>
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
                
                <!-- Messages Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb mb-0" style="background: white; border-radius: 10px; padding: 15px 20px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="bi bi-house"></i> Trang chủ
                                </a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Tin nhắn</li>
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

                    <!-- Header Card -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">
                                        <i class="bi bi-chat-dots me-2"></i>
                                        Tin nhắn
                                        <c:if test="${unreadCount > 0}">
                                            <span class="badge bg-light text-primary ms-2">${unreadCount} mới</span>
                                        </c:if>
                                    </h5>
                                </div>
                                <div class="col-auto">
                                    <a href="${pageContext.request.contextPath}/admin/messages/compose" class="btn btn-light">
                                        <i class="bi bi-plus-circle me-1"></i>
                                        Soạn tin nhắn mới
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Message Statistics -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <i class="bi bi-inbox fs-1 mb-2"></i>
                                    <h3>${unreadCount}</h3>
                                    <p class="mb-0">Tin nhắn chưa đọc</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-success text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-people fs-1 mb-2"></i>
                                    <h3>${contacts.size()}</h3>
                                    <p class="mb-0">Cuộc trò chuyện</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-info text-white">
                                <div class="card-body text-center">
                                    <i class="bi bi-chat-square-dots fs-1 mb-2"></i>
                                    <h3>Tin nhắn</h3>
                                    <p class="mb-0">Hệ thống</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Messages List -->
                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">
                                <i class="bi bi-list-ul me-2"></i>
                                Danh sách cuộc trò chuyện
                            </h6>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty contacts}">
                                    <div class="row">
                                        <c:forEach var="contact" items="${contacts}">
                                            <div class="col-12">
                                                <div class="message-item" onclick="openConversation(${contact.userId})">
                                                    <div class="row align-items-center">
                                                        <div class="col-auto">
                                                            <div class="contact-avatar user-avatar">
                                                                ${contact.fullName.substring(0, 1).toUpperCase()}
                                                            </div>
                                                        </div>
                                                        <div class="col">
                                                            <div class="d-flex justify-content-between align-items-start">
                                                                <div>
                                                                    <div class="contact-name">${contact.fullName}</div>
                                                                    <div class="text-muted small">
                                                                        <span class="role-badge">Người dùng</span>
                                                                        <span class="ms-2">@${contact.username}</span>
                                                                    </div>
                                                                </div>
                                                                <div class="text-end">
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-clock me-1"></i>Mới nhất
                                                                    </small>
                                                                    <br>
                                                                    <i class="bi bi-arrow-right text-primary"></i>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="bi bi-chat-dots fs-1 text-muted mb-3"></i>
                                        <h5 class="text-muted">Chưa có cuộc trò chuyện nào</h5>
                                        <p class="text-muted">Bắt đầu cuộc trò chuyện bằng cách soạn tin nhắn mới</p>
                                        <a href="${pageContext.request.contextPath}/admin/messages/compose" class="btn btn-primary">
                                            <i class="bi bi-plus-circle me-1"></i>
                                            Soạn tin nhắn mới
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openConversation(userId) {
            window.location.href = '${pageContext.request.contextPath}/admin/messages/conversation/' + userId;
        }

        // Auto refresh unread count every 30 seconds
        setInterval(function() {
            fetch('${pageContext.request.contextPath}/admin/messages/unread-count')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update badge in sidebar
                        const sidebarBadge = document.querySelector('.nav-link.active .badge');
                        if (data.count > 0) {
                            if (sidebarBadge) {
                                sidebarBadge.textContent = data.count;
                            } else {
                                const navLink = document.querySelector('.nav-link.active');
                                navLink.innerHTML += '<span class="badge bg-danger ms-2">' + data.count + '</span>';
                            }
                        } else if (sidebarBadge) {
                            sidebarBadge.remove();
                        }
                        
                        // Update stats card
                        const statsCard = document.querySelector('.stats-card h3');
                        if (statsCard) {
                            statsCard.textContent = data.count;
                        }
                    }
                })
                .catch(error => console.error('Error:', error));
        }, 30000);
    </script>
</body>
</html>
