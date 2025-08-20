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
                
                <!-- Compose Content -->
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

                    <!-- Recipient Selection Card -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-people me-2"></i>
                                Chọn người nhận
                            </h5>
                        </div>
                        <div class="card-body">
                            
                            <c:choose>
                                <c:when test="${not empty recipients}">
                                    <div class="row selection-grid">
                                        <c:forEach var="recipient" items="${recipients}">
                                            <div class="col-md-6 col-lg-4 mb-3">
                                                <div class="card h-100" style="cursor: pointer;" onclick="selectRecipient(${recipient.userId}, '${recipient.fullName}')">
                                                    <div class="card-body">
                                                        <div class="d-flex align-items-center">
                                                            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px;">
                                                                ${recipient.fullName.substring(0, 1).toUpperCase()}
                                                            </div>
                                                            <div class="flex-grow-1">
                                                                <h6 class="mb-1">${recipient.fullName}</h6>
                                                                <small class="text-muted">
                                                                    <i class="bi bi-envelope me-1"></i>
                                                                    ${recipient.email}
                                                                </small>
                                                                <c:if test="${not empty recipient.phone}">
                                                                    <br>
                                                                    <small class="text-muted">
                                                                        <i class="bi bi-telephone me-1"></i>
                                                                        ${recipient.phone}
                                                                    </small>
                                                                </c:if>
                                                            </div>
                                                            <div class="form-check">
                                                                <input class="form-check-input recipient-radio" 
                                                                       type="radio" 
                                                                       name="recipientId" 
                                                                       value="${recipient.userId}"
                                                                       required>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4">
                                        <i class="bi bi-people fs-1 text-muted mb-3"></i>
                                        <h5 class="text-muted">Không có người dùng nào</h5>
                                        <p class="text-muted">Hiện tại chưa có người dùng nào trong hệ thống</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Message Compose Card -->
                    <div class="card" style="display: none;" id="messageForm">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="bi bi-pencil-square me-2"></i>
                                Soạn tin nhắn
                            </h5>
                        </div>
                        <div class="card-body">
                        
                        <form action="${pageContext.request.contextPath}/admin/messages/compose" method="post" onsubmit="return validateForm()">
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

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-send me-2"></i>Gửi tin nhắn
                                </button>
                                <button type="button" class="btn btn-outline-secondary" onclick="clearSelection()">
                                    <i class="bi bi-x-circle me-2"></i>Hủy chọn
                                </button>
                                <a href="${pageContext.request.contextPath}/admin/messages" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-left me-2"></i>Quay lại
                                </a>
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
        let selectedRecipientId = null;

        function selectRecipient(userId, fullName) {
            // Check the radio button
            const selectedCard = event.currentTarget;
            const radio = selectedCard.querySelector('.recipient-radio');
            radio.checked = true;
            
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
            // Clear radio buttons
            document.querySelectorAll('.recipient-radio').forEach(radio => {
                radio.checked = false;
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
        
        // Add click listeners to cards for better UX
        document.querySelectorAll('.card[onclick]').forEach(card => {
            const radio = card.querySelector('.recipient-radio');
            card.addEventListener('click', function(e) {
                if (e.target.type !== 'radio') {
                    const userId = radio.value;
                    const fullName = card.querySelector('h6').textContent;
                    selectRecipient(userId, fullName);
                }
            });
        });
    </script>
</body>
</html>
