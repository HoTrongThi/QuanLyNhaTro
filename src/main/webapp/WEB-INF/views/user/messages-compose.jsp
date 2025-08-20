<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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

        .recipient-item {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
        }
        
        .recipient-item:hover {
            background: #f8f9fa;
            border-color: #28a745;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .recipient-item.selected {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.1) 0%, rgba(32, 201, 151, 0.1) 100%);
            border-color: #28a745;
            border-width: 2px;
        }
        
        .recipient-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }
        
        .role-badge {
            font-size: 11px;
            padding: 3px 8px;
            border-radius: 12px;
            color: white;
            background: #dc3545;
        }

        .message-form {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 15px;
            padding: 25px;
            margin-top: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .char-counter {
            text-align: right;
            font-size: 12px;
        }

        .unread-badge {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            color: white;
            font-size: 10px;
            padding: 4px 8px;
            border-radius: 12px;
            font-weight: 600;
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
                                <span class="unread-badge ms-2">${unreadCount}</span>
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
                
                <!-- Compose Content -->
                <div class="p-4">
                    <!-- Back Button -->
                    <div class="mb-3">
                        <a href="${pageContext.request.contextPath}/user/messages" class="btn btn-outline-primary">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại hộp thư
                        </a>
                    </div>

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
                            <h5 class="mb-0">
                                <i class="bi bi-pencil-square me-2"></i>
                                Soạn tin nhắn mới
                            </h5>
                        </div>
                        <div class="card-body">
                            <!-- Recipient Selection -->
                            <h6 class="mb-3">
                                <i class="bi bi-people me-2"></i>
                                Chọn người nhận (Quản trị viên):
                            </h6>
                            
                            <c:choose>
                                <c:when test="${not empty recipients}">
                                    <div class="row">
                                        <c:forEach var="recipient" items="${recipients}">
                                            <div class="col-lg-6 col-xl-4 mb-3">
                                                <div class="recipient-item" onclick="selectRecipient(${recipient.userId}, '${recipient.fullName}')">
                                                    <div class="d-flex align-items-center">
                                                        <div class="recipient-avatar">
                                                            ${recipient.fullName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div class="ms-3">
                                                            <div class="fw-bold">${recipient.fullName}</div>
                                                            <small class="text-muted">
                                                                <i class="bi bi-shield-check me-1"></i>@${recipient.username}
                                                                <span class="role-badge ms-1">Quản trị viên</span>
                                                            </small>
                                                            <c:if test="${not empty recipient.email}">
                                                                <br><small class="text-muted">
                                                                    <i class="bi bi-envelope me-1"></i>${recipient.email}
                                                                </small>
                                                            </c:if>
                                                        </div>
                                                        <div class="ms-auto">
                                                            <i class="bi bi-chevron-right text-primary"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="bi bi-person-exclamation fs-1 text-muted mb-3"></i>
                                        <h5 class="text-muted">Không có quản trị viên nào</h5>
                                        <p class="text-muted">Hiện tại chưa có quản trị viên nào trong hệ thống</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <!-- Message Form -->
                            <div class="message-form" style="display: none;" id="messageForm">
                                <form action="${pageContext.request.contextPath}/user/messages/compose" method="post" onsubmit="return validateForm()">
                                    <input type="hidden" name="receiverId" id="selectedRecipientId">
                                    
                                    <div class="mb-4">
                                        <label class="form-label">
                                            <i class="bi bi-person-check me-2"></i>Người nhận:
                                        </label>
                                        <div class="form-control-plaintext bg-light p-3 rounded" id="selectedRecipientName">
                                            <i class="bi bi-arrow-up me-2"></i>Chưa chọn người nhận
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label for="messageContent" class="form-label">
                                            <i class="bi bi-chat-text me-2"></i>Nội dung tin nhắn: <span class="text-danger">*</span>
                                        </label>
                                        <textarea name="content" 
                                                  id="messageContent" 
                                                  class="form-control" 
                                                  rows="8" 
                                                  placeholder="Nhập nội dung tin nhắn của bạn..."
                                                  required
                                                  maxlength="1000"></textarea>
                                        <div class="char-counter text-muted mt-2">
                                            <span id="charCount">0</span>/1000 ký tự
                                        </div>
                                    </div>

                                    <div class="d-flex justify-content-between">
                                        <button type="button" class="btn btn-secondary" onclick="clearSelection()">
                                            <i class="bi bi-x-circle me-1"></i>Hủy chọn
                                        </button>
                                        <button type="submit" class="btn btn-success">
                                            <i class="bi bi-send me-1"></i>Gửi tin nhắn
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Help Card -->
                    <div class="card">
                        <div class="card-body">
                            <h6><i class="bi bi-lightbulb me-2"></i>Hướng dẫn</h6>
                            <ul class="mb-0 text-muted">
                                <li>Chọn quản trị viên từ danh sách để gửi tin nhắn</li>
                                <li>Nội dung tin nhắn tối đa 1000 ký tự</li>
                                <li>Tin nhắn sẽ được gửi ngay lập tức đến quản trị viên</li>
                                <li>Bạn có thể theo dõi phản hồi từ hộp thư đến</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let selectedRecipientId = null;

        function selectRecipient(userId, fullName) {
            // Remove previous selection
            document.querySelectorAll('.recipient-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            // Add selection to clicked item
            event.currentTarget.classList.add('selected');
            
            // Set selected recipient
            selectedRecipientId = userId;
            document.getElementById('selectedRecipientId').value = userId;
            document.getElementById('selectedRecipientName').innerHTML = 
                '<i class="bi bi-person-check-fill text-success me-2"></i>' + fullName;
            
            // Show message form
            document.getElementById('messageForm').style.display = 'block';
            
            // Scroll to form
            document.getElementById('messageForm').scrollIntoView({ 
                behavior: 'smooth',
                block: 'start'
            });
            
            // Focus on textarea
            setTimeout(() => {
                document.getElementById('messageContent').focus();
            }, 500);
        }

        function clearSelection() {
            // Clear selection
            document.querySelectorAll('.recipient-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            selectedRecipientId = null;
            document.getElementById('selectedRecipientId').value = '';
            document.getElementById('selectedRecipientName').innerHTML = 
                '<i class="bi bi-arrow-up me-2"></i>Chưa chọn người nhận';
            document.getElementById('messageContent').value = '';
            
            // Hide message form
            document.getElementById('messageForm').style.display = 'none';
            
            // Update character counter
            updateCharCounter();
        }

        function validateForm() {
            if (!selectedRecipientId) {
                alert('Vui lòng chọn người nhận');
                return false;
            }
            
            const content = document.getElementById('messageContent').value.trim();
            if (!content) {
                alert('Vui lòng nhập nội dung tin nhắn');
                return false;
            }
            
            if (content.length > 1000) {
                alert('Nội dung tin nhắn không được vượt quá 1000 ký tự');
                return false;
            }
            
            return true;
        }

        function updateCharCounter() {
            const content = document.getElementById('messageContent').value;
            const charCount = content.length;
            const counter = document.getElementById('charCount');
            
            counter.textContent = charCount;
            
            if (charCount > 900) {
                counter.parentNode.classList.remove('text-muted', 'text-warning');
                counter.parentNode.classList.add('text-danger');
            } else if (charCount > 800) {
                counter.parentNode.classList.remove('text-muted', 'text-danger');
                counter.parentNode.classList.add('text-warning');
            } else {
                counter.parentNode.classList.remove('text-warning', 'text-danger');
                counter.parentNode.classList.add('text-muted');
            }
        }

        // Character counter
        document.getElementById('messageContent').addEventListener('input', updateCharCounter);

        // Auto-resize textarea
        document.getElementById('messageContent').addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = (this.scrollHeight) + 'px';
        });

        // Initialize character counter
        updateCharCounter();
    </script>
</body>
</html>
