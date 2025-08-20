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
        .sidebar.admin-theme {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: white;
        }
        
        .sidebar.user-theme {
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
        
        .card-header.admin-theme {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .card-header.user-theme {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px 15px 0 0 !important;
        }
        
        .chat-container {
            height: calc(100vh - 200px);
            display: flex;
            flex-direction: column;
        }
        
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px 8px 0 0;
        }
        
        .message-bubble {
            max-width: 70%;
            margin-bottom: 15px;
            padding: 12px 16px;
            border-radius: 18px;
            position: relative;
            word-wrap: break-word;
        }
        
        .message-sent.admin-theme {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-left: auto;
            border-bottom-right-radius: 4px;
        }
        
        .message-sent.user-theme {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            margin-left: auto;
            border-bottom-right-radius: 4px;
        }
        
        .message-received {
            background: white;
            color: #333;
            border: 1px solid #e9ecef;
            margin-right: auto;
            border-bottom-left-radius: 4px;
        }
        
        .message-time {
            font-size: 11px;
            opacity: 0.7;
            margin-top: 5px;
            display: block;
        }
        
        .message-sender {
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 5px;
            opacity: 0.8;
        }
        
        .chat-input {
            border-radius: 0 0 8px 8px;
            border-top: none;
            padding: 20px;
            background: white;
            border: 1px solid #dee2e6;
        }
        
        .user-info {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 15px;
            padding: 15px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 24px;
        }
        
        .admin-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .role-badge {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 12px;
            color: white;
        }
        
        .role-admin {
            background: #dc3545;
        }
        
        .role-user {
            background: #28a745;
        }
        
        .typing-indicator {
            display: none;
            padding: 10px;
            font-style: italic;
            color: #6c757d;
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
        
        .btn-primary.admin-theme {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .btn-primary.user-theme {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar ${isAdmin ? 'admin-theme' : 'user-theme'}">
                <div class="p-3">
                    <h4 class="text-center mb-4">
                        <c:choose>
                            <c:when test="${isAdmin}">
                                <i class="bi bi-building me-2"></i>
                                Admin Panel
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-house-door me-2"></i>
                                Phòng trọ
                            </c:otherwise>
                        </c:choose>
                    </h4>
                    
                    <div class="text-center mb-4">
                        <div class="bg-light text-dark rounded-circle d-inline-flex align-items-center justify-content-center" 
                             style="width: 60px; height: 60px;">
                            <c:choose>
                                <c:when test="${isAdmin}">
                                    <i class="bi bi-person-gear fs-3"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-person-circle fs-3"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="mt-2">
                            <strong>${user.fullName}</strong>
                            <br>
                            <small class="text-light">${isAdmin ? 'Quản trị viên' : 'Người thuê'}</small>
                        </div>
                    </div>
                    
                    <nav class="nav flex-column">
                        <c:choose>
                            <c:when test="${isAdmin}">
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
                                </a>
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/reports">
                                    <i class="bi bi-graph-up me-2"></i>
                                    Báo cáo & Thống kê
                                </a>
                            </c:when>
                            <c:otherwise>
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
                                </a>
                            </c:otherwise>
                        </c:choose>
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

                
                <!-- Conversation Content -->
                <div class="p-4">
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb" class="mb-4">
                        <ol class="breadcrumb mb-0" style="background: white; border-radius: 10px; padding: 15px 20px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                            <li class="breadcrumb-item">
                                <c:choose>
                                    <c:when test="${isAdmin}">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                                            <i class="bi bi-house"></i> Trang chủ
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/user/dashboard">
                                            <i class="bi bi-house"></i> Trang chủ
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <li class="breadcrumb-item">
                                <c:choose>
                                    <c:when test="${isAdmin}">
                                        <a href="${pageContext.request.contextPath}/admin/messages">Tin nhắn</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/user/messages">Tin nhắn</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Cuộc trò chuyện với ${otherUser.fullName}</li>
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

                    <!-- User Info -->
                    <c:if test="${not empty otherUser}">
                        <div class="user-info">
                            <div class="d-flex align-items-center">
                                <div class="user-avatar ${otherUser.role == 'ADMIN' ? 'admin-avatar' : ''}">
                                    ${otherUser.fullName.substring(0, 1).toUpperCase()}
                                </div>
                                <div class="ms-3">
                                    <h5 class="mb-1">${otherUser.fullName}</h5>
                                    <span class="role-badge ${otherUser.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                        ${otherUser.role == 'ADMIN' ? 'Quản trị viên' : 'Người dùng'}
                                    </span>
                                </div>
                                <div class="ms-auto">
                                    <small class="text-muted">
                                        <i class="bi bi-circle-fill text-success"></i> Online
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Chat Container -->
                    <div class="chat-container">
                        <!-- Messages -->
                        <div class="chat-messages" id="chatMessages">
                            <c:choose>
                                <c:when test="${not empty conversation}">
                                    <c:forEach var="message" items="${conversation}">
                                        <div class="message-bubble ${message.senderId == user.userId ? 'message-sent' : 'message-received'} ${isAdmin ? 'admin-theme' : 'user-theme'}">
                                            <c:if test="${message.senderId != user.userId}">
                                                <div class="message-sender">${message.senderName}</div>
                                            </c:if>
                                            <div class="message-content">
                                                ${message.content}
                                            </div>
                                            <small class="message-time">
                                                <i class="bi bi-clock me-1"></i> 
                                                <fmt:formatDate value="${message.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center text-muted py-5">
                                        <i class="bi bi-chat-dots fs-1 mb-3"></i>
                                        <h5>Chưa có tin nhắn nào</h5>
                                        <p>Bắt đầu cuộc trò chuyện bằng cách gửi tin nhắn đầu tiên</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="typing-indicator" id="typingIndicator">
                                <i class="bi bi-arrow-repeat spin"></i> Đang soạn tin nhắn...
                            </div>
                        </div>

                        <!-- Message Input -->
                        <div class="chat-input">
                            <c:choose>
                                <c:when test="${isAdmin}">
                                    <form action="${pageContext.request.contextPath}/admin/messages/send" method="post" id="messageForm">
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/user/messages/send" method="post" id="messageForm">
                                </c:otherwise>
                            </c:choose>
                                <input type="hidden" name="receiverId" value="${otherUserId}">
                                <div class="row align-items-end">
                                    <div class="col">
                                        <textarea name="content" 
                                                  class="form-control" 
                                                  rows="3" 
                                                  placeholder="Nhập tin nhắn của bạn..." 
                                                  required
                                                  maxlength="1000"
                                                  id="messageInput"></textarea>
                                        <small class="text-muted">Tối đa 1000 ký tự</small>
                                    </div>
                                    <div class="col-auto">
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary btn-lg ${isAdmin ? 'admin-theme' : 'user-theme'}">
                                                <i class="bi bi-send me-2"></i>Gửi
                                            </button>
                                            <c:choose>
                                                <c:when test="${isAdmin}">
                                                    <a href="${pageContext.request.contextPath}/admin/messages" class="btn btn-outline-secondary btn-lg">
                                                        <i class="bi bi-arrow-left me-2"></i>Quay lại
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/user/messages" class="btn btn-outline-secondary btn-lg">
                                                        <i class="bi bi-arrow-left me-2"></i>Quay lại
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto scroll to bottom
        function scrollToBottom() {
            const chatMessages = document.getElementById('chatMessages');
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
        
        // Scroll to bottom on page load
        window.addEventListener('load', scrollToBottom);

        // Handle form submission
        document.getElementById('messageForm').addEventListener('submit', function() {
            const messageInput = document.getElementById('messageInput');
            if (messageInput.value.trim() === '') {
                alert('Vui lòng nhập nội dung tin nhắn');
                return false;
            }
        });

        // Handle Enter key to send message (Ctrl+Enter for new line)
        document.getElementById('messageInput').addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.ctrlKey && !e.shiftKey) {
                e.preventDefault();
                document.getElementById('messageForm').submit();
            }
        });

        // Auto-resize textarea
        document.getElementById('messageInput').addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });

        // Character counter
        document.getElementById('messageInput').addEventListener('input', function() {
            const remaining = 1000 - this.value.length;
            const small = this.parentNode.querySelector('small');
            if (remaining < 100) {
                small.textContent = `Còn lại ${remaining} ký tự`;
                small.className = remaining < 50 ? 'text-danger' : 'text-warning';
            } else {
                small.textContent = 'Tối đa 1000 ký tự';
                small.className = 'text-muted';
            }
        });

        // Auto refresh messages every 10 seconds
        setInterval(function() {
            // Only refresh if user is viewing the conversation
            if (document.visibilityState === 'visible') {
                location.reload();
            }
        }, 10000);

        // Mark messages as read when window gains focus
        window.addEventListener('focus', function() {
            // Auto-scroll to bottom when returning to conversation
            setTimeout(scrollToBottom, 100);
        });
    </script>
</body>
</html>
