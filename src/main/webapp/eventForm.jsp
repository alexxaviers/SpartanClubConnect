<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.EventDAO.ClubView" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.EventDAO.ManagedEventView" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%@ page import="edu.sjsu.cs157a.team1.util.CsrfUtil" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");
    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;
    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    request.setAttribute("activeNav", "createEvent");

    String csrfToken = CsrfUtil.getToken(session);

    ManagedEventView event = (ManagedEventView) request.getAttribute("event");
    List<ClubView> clubs = (List<ClubView>) request.getAttribute("clubs");
    String error = (String) request.getAttribute("error");
    boolean isEdit = event != null;

    boolean hasTitleParam = request.getParameterMap().containsKey("title");
    boolean hasDescriptionParam = request.getParameterMap().containsKey("description");
    boolean hasDateParam = request.getParameterMap().containsKey("date");
    boolean hasStartTimeParam = request.getParameterMap().containsKey("startTime");
    boolean hasEndTimeParam = request.getParameterMap().containsKey("endTime");
    boolean hasLocationParam = request.getParameterMap().containsKey("location");
    boolean hasCapacityParam = request.getParameterMap().containsKey("capacity");
        boolean hasCategoryPresetParam = request.getParameterMap().containsKey("categoryPreset");
        boolean hasCategoryOtherParam = request.getParameterMap().containsKey("categoryOther");
    boolean hasImageUrlParam = request.getParameterMap().containsKey("imageUrl");
    boolean hasClubIdParam = request.getParameterMap().containsKey("clubId");

        String[] categoryOptions = new String[] {
            "Academic",
            "Workshop",
            "Networking / Career",
            "Social",
            "Volunteer / Service",
            "Competition / Tournament",
            "Performance / Showcase",
            "Sports / Recreation"
        };

    String titleValue = hasTitleParam ? request.getParameter("title") : (isEdit && event.getTitle() != null ? event.getTitle() : "");
    String descriptionValue = hasDescriptionParam ? request.getParameter("description") : (isEdit && event.getDescription() != null ? event.getDescription() : "");
    String dateValue = hasDateParam ? request.getParameter("date") : (isEdit && event.getDate() != null ? event.getDate().toString() : "");
    String startTimeValue = hasStartTimeParam ? request.getParameter("startTime") : (isEdit && event.getStartTime() != null ? event.getStartTime().toString().substring(0, 5) : "");
    String endTimeValue = hasEndTimeParam ? request.getParameter("endTime") : (isEdit && event.getEndTime() != null ? event.getEndTime().toString().substring(0, 5) : "");
    String locationValue = hasLocationParam ? request.getParameter("location") : (isEdit && event.getLocation() != null ? event.getLocation() : "");
    String capacityValue = hasCapacityParam ? request.getParameter("capacity") : (isEdit && event.getCapacity() != null ? event.getCapacity().toString() : "");
    String imageUrlValue = hasImageUrlParam ? request.getParameter("imageUrl") : (isEdit && event.getImageUrl() != null ? event.getImageUrl() : "");
    String clubIdValue = hasClubIdParam ? request.getParameter("clubId") : "";

    String categoryPresetValue = "";
    String categoryOtherValue = "";
    boolean showOtherCategory = false;

    if (hasCategoryPresetParam || hasCategoryOtherParam) {
        categoryPresetValue = request.getParameter("categoryPreset") != null ? request.getParameter("categoryPreset") : "";
        categoryOtherValue = request.getParameter("categoryOther") != null ? request.getParameter("categoryOther") : "";
        showOtherCategory = "other".equals(categoryPresetValue);
    } else if (isEdit && event.getCategory() != null && !event.getCategory().isEmpty()) {
        boolean matchedPreset = false;
        for (String option : categoryOptions) {
            if (option.equals(event.getCategory())) {
                categoryPresetValue = option;
                matchedPreset = true;
                break;
            }
        }
        if (!matchedPreset) {
            categoryPresetValue = "other";
            categoryOtherValue = event.getCategory();
            showOtherCategory = true;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Event" : "Create Event" %> - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title"><%= isEdit ? "Edit Event" : "Create Event" %></h1>
                <p class="dashboard-page-subtitle">
                    Publish an event for one of the clubs you manage.
                </p>
            </section>

            <section class="dashboard-form-card">
                <% if (error != null && !error.isEmpty()) { %>
                <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
                <% } %>

                <form class="club-form event-form" action="<%= ctx %>/officer-event" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <% if (isEdit) { %>
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <div class="form-group">
                        <label>Club</label>
                        <input type="text" value="<%= HtmlEscape.escape(event.getClubName()) %>" readonly>
                    </div>
                    <% } else { %>
                    <div class="form-group">
                        <label for="clubId">Club *</label>
                        <select id="clubId" name="clubId" required>
                            <option value="">Select a club</option>
                            <% if (clubs != null) {
                                for (ClubView club : clubs) { %>
                            <option value="<%= club.getClubId() %>" <%= Integer.toString(club.getClubId()).equals(clubIdValue) ? "selected" : "" %>><%= HtmlEscape.escape(club.getClubName()) %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <% } %>

                    <div class="form-group">
                        <label for="title">Title *</label>
                        <input type="text" id="title" name="title" maxlength="200" required value="<%= HtmlEscape.escape(titleValue) %>">
                    </div>

                    <div class="form-group">
                        <label for="description">Description *</label>
                        <textarea id="description" name="description" rows="5" required><%= HtmlEscape.escape(descriptionValue) %></textarea>
                    </div>

                    <div class="form-group">
                        <label for="date">Date *</label>
                        <input type="date" id="date" name="date" required value="<%= HtmlEscape.escape(dateValue) %>">
                    </div>

                    <div class="form-group event-time-grid">
                        <div>
                            <label for="startTime">Start Time *</label>
                            <input type="time" id="startTime" name="startTime" required value="<%= HtmlEscape.escape(startTimeValue) %>">
                        </div>
                        <div>
                            <label for="endTime">End Time *</label>
                            <input type="time" id="endTime" name="endTime" required value="<%= HtmlEscape.escape(endTimeValue) %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="location">Location *</label>
                        <input type="text" id="location" name="location" maxlength="200" required value="<%= HtmlEscape.escape(locationValue) %>">
                    </div>

                    <div class="form-group">
                        <label for="capacity">Capacity (optional)</label>
                        <input type="number" id="capacity" name="capacity" min="1" value="<%= HtmlEscape.escape(capacityValue) %>">
                    </div>

                    <div class="form-group">
                        <label>Category (optional)</label>
                        <div class="event-category-options" data-category-options>
                            <% for (String option : categoryOptions) { %>
                            <label class="event-category-option">
                                <input type="radio" name="categoryPreset" value="<%= HtmlEscape.escape(option) %>" <%= option.equals(categoryPresetValue) ? "checked" : "" %>>
                                <span><%= HtmlEscape.escape(option) %></span>
                            </label>
                            <% } %>
                            <label class="event-category-option">
                                <input type="radio" name="categoryPreset" value="other" <%= "other".equals(categoryPresetValue) ? "checked" : "" %>>
                                <span>Other</span>
                            </label>
                        </div>
                    </div>

                    <div class="form-group event-other-category <%= showOtherCategory ? "" : "is-hidden" %>" data-category-other-field>
                        <label for="categoryOther">Custom category (optional)</label>
                        <input type="text" id="categoryOther" name="categoryOther" maxlength="100" value="<%= HtmlEscape.escape(categoryOtherValue) %>" placeholder="Enter a custom category">
                    </div>

                    <div class="form-group">
                        <label for="imageUrl">Image URL (optional)</label>
                        <input type="url" id="imageUrl" name="imageUrl" maxlength="255" value="<%= HtmlEscape.escape(imageUrlValue) %>">
                    </div>

                    <button type="submit" class="primary-btn"><%= isEdit ? "Save Changes" : "Publish Event" %></button>
                </form>
            </section>
            <script>
                (function () {
                    const optionsWrap = document.querySelector('[data-category-options]');
                    const otherField = document.querySelector('[data-category-other-field]');
                    if (!optionsWrap || !otherField) {
                        return;
                    }

                    const radios = optionsWrap.querySelectorAll('input[type="radio"][name="categoryPreset"]');
                    const toggleOtherField = () => {
                        const selected = optionsWrap.querySelector('input[type="radio"][name="categoryPreset"]:checked');
                        otherField.classList.toggle('is-hidden', !selected || selected.value !== 'other');
                    };

                    radios.forEach((radio) => radio.addEventListener('change', toggleOtherField));
                    toggleOtherField();
                })();
            </script>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>
