
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String error = request.getParameter("error");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>SmartFix - Raise Complaint</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f7fb;
            color: #1e293b;
        }

        .page {
            min-height: 100vh;
            padding: 25px 18px 40px;
        }

        .topbar {
            max-width: 1100px;
            margin: 0 auto 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .brand-logo {
            width: 43px;
            height: 43px;
            display: grid;
            place-items: center;
            border-radius: 12px;
            background: #2563eb;
            color: white;
            font-size: 22px;
            font-weight: bold;
        }

        .brand h1 {
            margin: 0;
            font-size: 23px;
        }

        .brand p {
            margin: 4px 0 0;
            color: #64748b;
            font-size: 12px;
        }

        .back-link {
            text-decoration: none;
            color: #2563eb;
            font-size: 14px;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .page-heading {
            max-width: 1100px;
            margin: 0 auto 22px;
        }

        .page-heading h2 {
            margin: 0 0 8px;
            font-size: 27px;
        }

        .page-heading p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
        }

        .layout {
            max-width: 1100px;
            margin: auto;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 290px;
            gap: 22px;
            align-items: start;
        }

        .card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 25px;
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04);
        }

        .card-heading {
            margin-bottom: 23px;
        }

        .card-heading h3 {
            margin: 0 0 7px;
            font-size: 19px;
        }

        .card-heading p {
            margin: 0;
            color: #64748b;
            font-size: 13px;
            line-height: 1.5;
        }

        .error-message {
            margin-bottom: 18px;
            padding: 12px 14px;
            border: 1px solid #fecaca;
            border-radius: 8px;
            background: #fef2f2;
            color: #b91c1c;
            font-size: 13px;
            overflow-wrap: anywhere;
        }

        .form-group {
            margin-bottom: 19px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: bold;
            color: #334155;
        }

        .required {
            color: #dc2626;
        }

        .optional {
            color: #64748b;
            font-weight: normal;
        }

        .form-control {
            width: 100%;
            padding: 12px 13px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: white;
            color: #1e293b;
            font: inherit;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        textarea.form-control {
            min-height: 125px;
            resize: vertical;
            line-height: 1.6;
        }

        select.form-control {
            cursor: pointer;
        }

        .field-help {
            margin-top: 7px;
            color: #64748b;
            font-size: 12px;
            line-height: 1.5;
        }

        .priority-help {
            display: flex;
            flex-wrap: wrap;
            gap: 7px;
            margin-top: 10px;
        }

        .priority-tag {
            padding: 6px 9px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: bold;
        }

        .low {
            background: #ecfdf5;
            color: #047857;
        }

        .medium {
            background: #fff7ed;
            color: #c2410c;
        }

        .high {
            background: #fef2f2;
            color: #b91c1c;
        }

        .upload-box {
            padding: 18px;
            border: 1px dashed #94a3b8;
            border-radius: 10px;
            background: #f8fafc;
        }

        .upload-box input {
            width: 100%;
            font-size: 13px;
        }

        .image-error {
            display: none;
            margin-top: 10px;
            color: #b91c1c;
            font-size: 12px;
        }

        .image-error.show {
            display: block;
        }

        .preview-wrapper {
            display: none;
            margin-top: 14px;
        }

        .preview-wrapper.show {
            display: block;
        }

        .image-preview {
            display: block;
            max-width: 100%;
            max-height: 220px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            object-fit: contain;
        }

        .preview-name {
            margin-top: 7px;
            font-size: 12px;
            color: #64748b;
            overflow-wrap: anywhere;
        }

        .form-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 43px;
            padding: 11px 17px;
            border-radius: 8px;
            font: inherit;
            font-size: 13px;
            font-weight: bold;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.2s;
        }

        .submit-btn {
            border: 1px solid #2563eb;
            background: #2563eb;
            color: white;
        }

        .submit-btn:hover {
            background: #1d4ed8;
        }

        .cancel-btn {
            border: 1px solid #cbd5e1;
            background: white;
            color: #334155;
        }

        .cancel-btn:hover {
            background: #f1f5f9;
        }

        .guide-card h3 {
            margin: 0 0 19px;
            font-size: 18px;
        }

        .guide-item {
            display: flex;
            gap: 11px;
            padding: 14px 0;
            border-bottom: 1px solid #edf2f7;
        }

        .guide-item:last-of-type {
            border-bottom: none;
        }

        .guide-number {
            flex-shrink: 0;
            width: 29px;
            height: 29px;
            display: grid;
            place-items: center;
            border-radius: 8px;
            background: #eff6ff;
            color: #2563eb;
            font-size: 12px;
            font-weight: bold;
        }

        .guide-item h4 {
            margin: 2px 0 5px;
            font-size: 13px;
        }

        .guide-item p {
            margin: 0;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        .status-note {
            margin-top: 17px;
            padding: 14px;
            border-radius: 9px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }

        .status-note strong {
            font-size: 12px;
        }

        .status-note p {
            margin: 7px 0 0;
            color: #64748b;
            font-size: 12px;
            line-height: 1.6;
        }

        @media (max-width: 800px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .guide-card {
                order: 2;
            }
        }

        @media (max-width: 500px) {
            .page {
                padding: 18px 12px 28px;
            }

            .brand h1 {
                font-size: 20px;
            }

            .brand p {
                font-size: 11px;
            }

            .page-heading h2 {
                font-size: 23px;
            }

            .card {
                padding: 19px;
            }

            .topbar {
                align-items: flex-start;
            }

            .back-link {
                font-size: 12px;
                padding-top: 8px;
            }

            .form-actions {
                flex-direction: column;
            }

            .form-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="page">

    <header class="topbar">
        <div class="brand">
            <div class="brand-logo">S</div>
            <div>
                <h1>SmartFix</h1>
                <p>Complaint &amp; Service Management System</p>
            </div>
        </div>

        <a class="back-link"
           href="<%= contextPath %>/user/dashboard.jsp">
            ← Dashboard
        </a>
    </header>

    <section class="page-heading">
        <h2>Raise a Complaint</h2>
        <p>
            Tell us about the problem. Provide the details below
            so the service team can review your complaint.
        </p>
    </section>

    <main class="layout">

        <section class="card">
            <div class="card-heading">
                <h3>Complaint Details</h3>
                <p>Fields marked with <span class="required">*</span> are required.</p>
            </div>

            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="error-message" role="alert">
                    <%= error %>
                </div>
            <% } %>

            <form
                action="<%= contextPath %>/addComplaint"
                method="post"
                enctype="multipart/form-data"
                id="complaintForm">

                <div class="form-group">
                    <label for="title">
                        Complaint Title <span class="required">*</span>
                    </label>
                    <input
                        type="text"
                        id="title"
                        name="title"
                        class="form-control"
                        placeholder="e.g. Fan is not working"
                        maxlength="150"
                        required>
                </div>

                <div class="form-group">
                    <label for="description">
                        Description <span class="required">*</span>
                    </label>
                    <textarea
                        id="description"
                        name="description"
                        class="form-control"
                        placeholder="Explain the problem and where it occurred..."
                        required></textarea>
                </div>

                <div class="form-group">
                    <label for="category">
                        Category <span class="required">*</span>
                    </label>
                    <select
                        id="category"
                        name="category"
                        class="form-control"
                        required>
                        <option value="">Select a category</option>
                        <option value="Electrical">Electrical</option>
                        <option value="Plumbing">Plumbing</option>
                        <option value="Internet">Internet</option>
                        <option value="Cleaning">Cleaning</option>
                        <option value="Maintenance">Maintenance</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="priority">
                        Priority <span class="required">*</span>
                    </label>
                    <select
                        id="priority"
                        name="priority"
                        class="form-control"
                        required>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM" selected>Medium</option>
                        <option value="HIGH">High</option>
                    </select>

                    <div class="priority-help">
                        <span class="priority-tag low">Low — Normal</span>
                        <span class="priority-tag medium">Medium — Needs attention</span>
                        <span class="priority-tag high">High — Urgent</span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="complaintImage">
                        Complaint Image <span class="optional">(Optional)</span>
                    </label>

                    <div class="upload-box">
                        <input
                            type="file"
                            id="complaintImage"
                            name="complaintImage"
                            accept=".jpg,.jpeg,.png,.gif,.webp,image/jpeg,image/png,image/gif,image/webp">

                        <p class="field-help">
                            JPG, PNG, GIF or WEBP. Maximum size: 5 MB.
                        </p>

                        <div id="imageError" class="image-error" role="alert"></div>

                        <div id="previewWrapper" class="preview-wrapper">
                            <img id="imagePreview"
                                 class="image-preview"
                                 alt="Preview of selected complaint image">
                            <div id="previewName" class="preview-name"></div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn submit-btn">
                        Submit Complaint
                    </button>

                    <a href="<%= contextPath %>/user/dashboard.jsp"
                       class="btn cancel-btn">
                        Cancel
                    </a>
                </div>
            </form>
        </section>

        <aside class="card guide-card">
            <h3>How It Works</h3>

            <div class="guide-item">
                <div class="guide-number">1</div>
                <div>
                    <h4>Submit your complaint</h4>
                    <p>Describe the issue and choose its category and priority.</p>
                </div>
            </div>

            <div class="guide-item">
                <div class="guide-number">2</div>
                <div>
                    <h4>Team reviews it</h4>
                    <p>The service team reviews the information you submit.</p>
                </div>
            </div>

            <div class="guide-item">
                <div class="guide-number">3</div>
                <div>
                    <h4>Staff handles the issue</h4>
                    <p>Your complaint can be assigned to a suitable staff member.</p>
                </div>
            </div>

            <div class="guide-item">
                <div class="guide-number">4</div>
                <div>
                    <h4>Track progress</h4>
                    <p>Check your complaints page for status updates.</p>
                </div>
            </div>

            <div class="status-note">
                <strong>Complaint status</strong>
                <p>Pending → Assigned → In Progress → Resolved</p>
            </div>
        </aside>

    </main>
</div>

<script>
    const imageInput = document.getElementById("complaintImage");
    const imageError = document.getElementById("imageError");
    const previewWrapper = document.getElementById("previewWrapper");
    const imagePreview = document.getElementById("imagePreview");
    const previewName = document.getElementById("previewName");

    const allowedTypes = [
        "image/jpeg",
        "image/png",
        "image/gif",
        "image/webp"
    ];

    const maxSize = 5 * 1024 * 1024;

    imageInput.addEventListener("change", function () {
        imageError.textContent = "";
        imageError.classList.remove("show");
        previewWrapper.classList.remove("show");
        imagePreview.removeAttribute("src");

        const file = this.files[0];

        if (!file) {
            return;
        }

        if (!allowedTypes.includes(file.type)) {
            showImageError("Please select a JPG, PNG, GIF or WEBP image.");
            this.value = "";
            return;
        }

        if (file.size > maxSize) {
            showImageError("The image exceeds 5 MB. Please select a smaller image.");
            this.value = "";
            return;
        }

        const reader = new FileReader();

        reader.onload = function (event) {
            imagePreview.src = event.target.result;
            previewName.textContent = file.name + " (" + formatSize(file.size) + ")";
            previewWrapper.classList.add("show");
        };

        reader.onerror = function () {
            showImageError("Unable to preview this image. Please select it again.");
            imageInput.value = "";
        };

        reader.readAsDataURL(file);
    });

    function showImageError(message) {
        imageError.textContent = message;
        imageError.classList.add("show");
    }

    function formatSize(bytes) {
        if (bytes < 1024 * 1024) {
            return (bytes / 1024).toFixed(1) + " KB";
        }

        return (bytes / (1024 * 1024)).toFixed(2) + " MB";
    }
</script>

</body>
</html>
