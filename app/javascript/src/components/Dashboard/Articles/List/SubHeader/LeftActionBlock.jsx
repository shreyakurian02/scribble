import React from "react";

import { Typography, Button, Dropdown, Tag } from "neetoui";
import { isEmpty } from "ramda";
import { useTranslation, Trans } from "react-i18next";
import { useHistory } from "react-router";
import { v4 as uuid } from "uuid";

import { getCategoryOptions } from "components/Dashboard/utils";
import { useFetchCategories } from "hooks/reactQuery/useCategoriesApi";

import { ARTICLE_STATUS } from "../../constants";
import { getQueryParams, handleFilterByCategories } from "../../utils";

const {
  Menu,
  MenuItem: { Button: MenuButton },
} = Dropdown;

const LeftActionBlock = ({
  selectedRowsCount,
  articlesCount = 0,
  setBulkUpdateData,
  setIsBulkDeleteAlertOpen,
}) => {
  const { t } = useTranslation();
  const history = useHistory();
  const { data: categories = [] } = useFetchCategories();

  const { search, categories: queryCategories } = getQueryParams();

  const categoryOptions = getCategoryOptions(categories);

  const handleCategoryClose = category =>
    handleFilterByCategories({
      queryCategories,
      history,
      selectedCategory: category,
    });

  const handleUpdateCategory = payload =>
    setBulkUpdateData({ isModalOpen: true, payload, type: "category" });

  const handleUpdateStatus = payload =>
    setBulkUpdateData({ isModalOpen: true, payload, type: "status" });

  if (selectedRowsCount === 0) {
    return (
      <div className="flex space-x-2">
        <Typography component="h4" style="h4">
          {isEmpty(search)
            ? t("common.articleWithCount", { count: articlesCount })
            : t("common.searchResult", { count: articlesCount, search })}
        </Typography>
        {queryCategories?.map(category => (
          <Tag
            className="p-1"
            key={uuid()}
            label={category}
            style="secondary"
            onClose={() => handleCategoryClose(category)}
          />
        ))}
      </div>
    );
  }

  return (
    <div className="flex items-center space-x-2">
      <Typography style="body1">
        <Trans
          i18nKey="common.selectedOf"
          values={{
            selectedCount: selectedRowsCount,
            resource: t("common.article", {
              count: selectedRowsCount,
            }).toLowerCase(),
            articlesCount,
          }}
        />
      </Typography>
      <Dropdown buttonStyle="secondary" label={t("button.changeCategory")}>
        <Menu>
          {categoryOptions.map(({ label, value }) => (
            <MenuButton
              key={value}
              onClick={() =>
                handleUpdateCategory({ categoryName: label, categoryId: value })
              }
            >
              {label}
            </MenuButton>
          ))}
        </Menu>
      </Dropdown>
      <Dropdown buttonStyle="secondary" label={t("button.changeStatus")}>
        <Menu>
          <MenuButton
            onClick={() => handleUpdateStatus({ status: ARTICLE_STATUS.draft })}
          >
            {t("common.draft")}
          </MenuButton>
          <MenuButton
            onClick={() =>
              handleUpdateStatus({ status: ARTICLE_STATUS.publish })
            }
          >
            {t("common.publish")}
          </MenuButton>
        </Menu>
      </Dropdown>
      <Button
        label={t("button.delete")}
        style="danger"
        onClick={() => setIsBulkDeleteAlertOpen(true)}
      />
    </div>
  );
};

export default LeftActionBlock;
