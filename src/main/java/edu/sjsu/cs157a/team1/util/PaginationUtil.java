package edu.sjsu.cs157a.team1.util;

import java.util.Collections;
import java.util.List;

public final class PaginationUtil {
    private PaginationUtil() {
    }

    public static int parsePage(String pageParam) {
        int page = 1;
        if (pageParam != null && !pageParam.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageParam.trim());
            } catch (NumberFormatException ignored) {
                page = 1;
            }
        }
        return page < 1 ? 1 : page;
    }

    public static <T> PageResult<T> paginate(List<T> items, int requestedPage, int pageSize) {
        if (items == null || items.isEmpty()) {
            return new PageResult<>(Collections.emptyList(), 1, 0, 0);
        }

        int safePageSize = pageSize > 0 ? pageSize : items.size();
        int totalItems = items.size();
        int totalPages = (int) Math.ceil(totalItems / (double) safePageSize);
        int currentPage = Math.min(Math.max(requestedPage, 1), totalPages);
        int fromIndex = (currentPage - 1) * safePageSize;
        int toIndex = Math.min(fromIndex + safePageSize, totalItems);

        return new PageResult<>(items.subList(fromIndex, toIndex), currentPage, totalPages, totalItems);
    }

    public static final class PageResult<T> {
        private final List<T> items;
        private final int currentPage;
        private final int totalPages;
        private final int totalItems;

        public PageResult(List<T> items, int currentPage, int totalPages, int totalItems) {
            this.items = items;
            this.currentPage = currentPage;
            this.totalPages = totalPages;
            this.totalItems = totalItems;
        }

        public List<T> getItems() {
            return items;
        }

        public int getCurrentPage() {
            return currentPage;
        }

        public int getTotalPages() {
            return totalPages;
        }

        public int getTotalItems() {
            return totalItems;
        }
    }
}
