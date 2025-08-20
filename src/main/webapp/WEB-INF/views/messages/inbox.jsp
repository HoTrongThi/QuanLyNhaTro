<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Quản Lý Phòng Trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .message-item {
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            background: white;
            transition: all 0.3s;
            cursor: pointer;
        }
        .message-item:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .message-item.unread {
            border-left: 4px solid #007bff;
            background: #f0f8ff;
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
        .admin-avatar {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .contact-name {
            font-weight: 600;
            color: #333;
        }
        .contact-role {
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 12px;
            color: white;
        }
        .role-admin {
            background: #dc3545;
        }
        .role-user {
            background: #28a745;
        }
        .sidebar {
            min-height: calc(100vh - 56px);
            background: #f8f9fa;
            border-right: 1px solid #dee2e6;
        }
        .content-area {
            min-height: calc(100vh - 56px);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-home"></i> Quản Lý Phòng Trọ
            </a>
            <div class="navbar-nav ms-auto">
                <div class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user"></i> ${user.fullName}
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="/QuanLyPhongTro/profile">Hồ sơ</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="/QuanLyPhongTro/logout">Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 sidebar p-3">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5><i class="fas fa-comments"></i> Tin nhắn</h5>
                    <span class="badge bg-primary">${unreadCount}</span>
                </div>
                
                <div class="d-grid gap-2 mb-4">
                    <c:choose>
                        <c:when test="${isAdmin}">
                            <a href="/QuanLyPhongTro/admin/messages/compose" class="btn btn-success">
                                <i class="fas fa-plus"></i> Soạn tin nhắn
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="/QuanLyPhongTro/user/messages/compose" class="btn btn-success">
                                <i class="fas fa-plus"></i> Soạn tin nhắn
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <hr>

                <!-- Back to Dashboard -->
                <div class="d-grid">
                    <c:choose>
                        <c:when test="${isAdmin}">
                            <a href="/QuanLyPhongTro/admin/dashboard" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="/QuanLyPhongTro/user/dashboard" class="btn btn-outline-primary">
                                <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 content-area p-4">
                <!-- Flash Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show">
                        <i class="fas fa-check-circle"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4>
                        <i class="fas fa-inbox"></i> Hộp thư đến
                        <c:if test="${unreadCount > 0}">
                            <span class="badge bg-danger">${unreadCount} mới</span>
                        </c:if>
                    </h4>
                </div>

                <!-- Contacts List -->
                <c:choose>
                    <c:when test="${not empty contacts}">
                        <div class="row">
                            <c:forEach var="contact" items="${contacts}">
                                <div class="col-12">
                                    <div class="message-item" onclick="openConversation(${contact.userId})">
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
                                                        <div class="text-muted small">
                                                            <span class="contact-role ${contact.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                                                ${contact.role == 'ADMIN' ? 'Quản trị viên' : 'Người dùng'}
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <div class="text-end">
                                                        <small class="text-muted">
                                                            <i class="fas fa-clock"></i> Vừa xong
                                                        </small>
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
                            <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Chưa có cuộc trò chuyện nào</h5>
                            <p class="text-muted">Bắt đầu cuộc trò chuyện bằng cách soạn tin nhắn mới</p>
                            <c:choose>
                                <c:when test="${isAdmin}">
                                    <a href="/QuanLyPhongTro/admin/messages/compose" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Soạn tin nhắn mới
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/QuanLyPhongTro/user/messages/compose" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Soạn tin nhắn mới
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openConversation(userId) {
            <c:choose>
                <c:when test="${isAdmin}">
                    window.location.href = '/QuanLyPhongTro/admin/messages/conversation/' + userId;
                </c:when>
                <c:otherwise>
                    window.location.href = '/QuanLyPhongTro/user/messages/conversation/' + userId;
                </c:otherwise>
            </c:choose>
        }

        // Auto refresh unread count every 30 seconds
        setInterval(function() {
            <c:choose>
                <c:when test="${isAdmin}">
                    var url = '/QuanLyPhongTro/admin/messages/unread-count';
                </c:when>
                <c:otherwise>
                    var url = '/QuanLyPhongTro/user/messages/unread-count';
                </c:otherwise>
            </c:choose>
            
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const badge = document.querySelector('.badge.bg-primary');
                        if (badge) {
                            badge.textContent = data.count;
                        }
                    }
                })
                .catch(error => console.error('Error:', error));
        }, 30000);
    </script>
</body>
</html>
