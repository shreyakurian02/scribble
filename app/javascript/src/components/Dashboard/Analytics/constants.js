import { SINGULAR } from "constants";

import { t } from "i18next";

import { renderArticleTitle, formatDate } from "components/Dashboard/utils";

export const SORT_ORDER = {
  ascend: "asc",
  descend: "desc",
};

export const COLUMN_DATA = [
  {
    dataIndex: "title",
    title: t("common.title"),
    key: "title",
    width: "25%",
    render: (title, { id }) => renderArticleTitle({ title, id }),
  },
  {
    dataIndex: "last_published_at",
    title: t("common.lastPublished"),
    key: "lastPublishedAt",
    width: "25%",
    render: date => (date ? formatDate(date) : "-"),
  },
  {
    dataIndex: "category",
    title: t("common.category", SINGULAR),
    key: "category",
    width: "20%",
  },
  {
    dataIndex: "views",
    title: t("common.visits"),
    key: "visits",
    width: "15%",
    sorter: true,
  },
  {
    dataIndex: "likes_count",
    title: t("common.likes"),
    key: "likes",
    width: "15%",
  },
];
