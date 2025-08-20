<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
        }

        .message-item {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            background: white;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .message-item:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border-color: #28a745;
        }
        
        .message-item.unread {
            border-left: 4px solid #28a745;
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.05) 0%, rgba(32, 201, 151, 0.05) 100%);
        }
        
        .contact-avatar {
            width: 55px;
            height: 55px;
            border-radius: 50%;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 20px;
            box-shadow: 0 4px 10px rgba(40, 167, 69, 0.3);
        }
        
        .admin-avatar {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            box-shadow: 0 4px 10px rgba(220, 53, 69, 0.3);
        }
        
        .contact-name {
            font-weight: 600;
            color: #333;
            font-size: 16px;
        }
        
        .contact-role {
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 15px;
            color: white;
            font-weight: 500;
        }
        
        .role-admin {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
        }
        
        .role-user {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }

        .compose-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 25px;
            padding: 12px 25px;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            transition: all 0.3s;
        }

        .compose-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.4);
        }

        .unread-badge {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            color: white;
            font-size: 10px;
            padding: 4px 8px;
            border-radius: 12px;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state i {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
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
                        <i class="bi bi-house-door me-2"></i>
                        Phòng trọ
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <i class="bi bi-person-circle fs-3"></i>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">Người thuê</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="bi bi-speedometer2 me-2"></i>
                            Bảng điều khiển
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/profile">
                            <i class="bi bi-person me-2"></i>
                            Thông tin cá nhân
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/room">
                            <i class="bi bi-house-door me-2"></i>
                            Thông tin Phòng
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/bills">
                            <i class="bi bi-receipt me-2"></i>
                            Hóa đơn của tôi
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/payments">
                            <i class="bi bi-credit-card me-2"></i>
                            Lịch sử Thanh toán
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/messages">
                            <i class="bi bi-chat-dots me-2"></i>
                            Tin nhắn
                            <c:if test="${unreadCount > 0}">
                                <span class="badge bg-danger ms-2">${unreadCount}</span>
                            </c:if>
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
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">Thông tin cá nhân</a></li>
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
                    <!-- Flash Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <i class="bi bi-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="bi bi-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Header Card -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="bi bi-inbox me-2"></i>
                                    Hộp thư đến
                                    <c:if test="${unreadCount > 0}">
                                        <span class="badge bg-light text-dark ms-2">${unreadCount} tin mới</span>
                                    </c:if>
                                </h5>
                                <a href="${pageContext.request.contextPath}/user/messages/compose" class="btn btn-light">
                                    <i class="bi bi-pencil-square me-2"></i>
                                    Soạn tin nhắn
                                </a>
                            </div>
                        </div>
                        <div class="card-body">
                            <!-- Messages List -->
                            <c:choose>
                                <c:when test="${not empty contacts}">
                                    <div class="row">
                                        <c:forEach var="contact" items="${contacts}">
                                            <div class="col-12">
                                                <div class="message-item ${contact.hasUnreadMessages ? 'unread' : ''}" 
                                                     onclick="openConversation(${contact.userId})">
                                                    <div class="row align-items-center">
                                                        <div class="col-auto">
                                                            <div class="contact-avatar ${contact.role == 'ADMIN' ? 'admin-avatar' : ''}">
                                                                ${contact.fullName.substring(0, 1).toUpperCase()}
                                                            </div>
                                                        </div>
                                                        <div class="col">
                                                            <div class="d-flex justify-content-between align-items-start">
                                                                <div>
                                                                    <div class="contact-name">${contact.fullName}</div>
                                                                    <div class="d-flex align-items-center mt-1">
                                                                        <span class="contact-role ${contact.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                                                            <i class="bi bi-${contact.role == 'ADMIN' ? 'shield-check' : 'person'} me-1"></i>
                                                                            ${contact.role == 'ADMIN' ? 'Quản trị viên' : 'Người dùng'}
                                                                        </span>
                                                                        <c:if test="${contact.hasUnreadMessages}">
                                                                            <span class="unread-badge ms-2">
                                                                                <i class="bi bi-dot"></i>Mới
                                                                            </span>
                                                                        </c:if>
                                                                    </div>
                                                    <c:if test="${not empty contact.lastMessage}">
                                                        <div class="text-muted mt-2" style="font-size: 14px;">
                                                            <i class="bi bi-chat-text me-1"></i>
                                                            <c:choose>
                                                                <c:when test="${contact.lastMessage.length() > 60}">
                                                                    ${contact.lastMessage.substring(0, 60)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${contact.lastMessage}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:if>
                                                                </div>
                                                                <div class="text-end">
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-clock me-1"></i>
                                                                        <c:choose>
                                                                            <c:when test="${not empty contact.lastMessageTime}">
                                                                                <fmt:formatDate value="${contact.lastMessageTime}" pattern="dd/MM HH:mm"/>
                                                                            </c:when>
                                                                            <c:otherwise>Vừa xong</c:otherwise>
                                                                        </c:choose>
                                                                    </small>
                                                                    <div class="mt-2">
                                                                        <i class="bi bi-chevron-right text-success"></i>
                                                                    </div>
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
                                    <div class="empty-state">
                                        <i class="bi bi-chat-dots"></i>
                                        <h5 class="text-muted">Chưa có cuộc trò chuyện nào</h5>
                                        <p class="text-muted mb-4">Bắt đầu cuộc trò chuyện đầu tiên với quản lý phòng trọ</p>
                                        <a href="${pageContext.request.contextPath}/user/messages/compose" class="btn btn-success compose-btn">
                                            <i class="bi bi-pencil-square me-2"></i>
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
            window.location.href = '${pageContext.request.contextPath}/user/messages/conversation/' + userId;
        }

        // Auto refresh unread count every 30 seconds
        setInterval(function() {
            fetch('${pageContext.request.contextPath}/user/messages/unread-count')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update sidebar badge
                        const sidebarBadge = document.querySelector('.sidebar .badge');
                        if (data.count > 0) {
                            if (sidebarBadge) {
                                sidebarBadge.textContent = data.count;
                            } else {
                                // Create badge if it doesn't exist
                                const messagesLink = document.querySelector('.sidebar a[href*="messages"]');
                                if (messagesLink) {
                                    const badge = document.createElement('span');
                                    badge.className = 'badge bg-danger ms-2';
                                    badge.textContent = data.count;
                                    messagesLink.appendChild(badge);
                                }
                            }
                        } else {
                            if (sidebarBadge) {
                                sidebarBadge.remove();
                            }
                        }

                        // Update header badge
                        const headerBadge = document.querySelector('.card-header .badge');
                        if (data.count > 0) {
                            if (headerBadge) {
                                headerBadge.textContent = data.count + ' tin mới';
                            }
                        } else {
                            if (headerBadge) {
                                headerBadge.remove();
                            }
                        }
                    }
                })
                .catch(error => console.error('Error:', error));
        }, 30000);

        // Add smooth hover effects
        document.querySelectorAll('.message-item').forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-3px)';
            });
            
            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
            });
        });
    </script>
</body>
</html>
