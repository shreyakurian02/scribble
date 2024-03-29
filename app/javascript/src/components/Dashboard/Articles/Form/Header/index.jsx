import React, { useState, useEffect } from "react";

import { useFormikContext } from "formik";
import { MenuHorizontal } from "neetoicons";
import { Button, Dropdown, Typography } from "neetoui";
import { Select } from "neetoui/formik";
import { useTranslation, Trans } from "react-i18next";
import { useHistory, useParams } from "react-router";

import { getCategoryOptions } from "components/Dashboard/utils";
import { ARTICLES_URL } from "constants/urls";
import { useShowArticle } from "hooks/reactQuery/useArticlesApi";
import {
  useFetchCategories,
  useCreateCategory,
} from "hooks/reactQuery/useCategoriesApi";

import SaveButton from "./SaveButton";

import { MANAGE_DELETE_ALERT_INITIAL_VALUE } from "../../constants";
import { Delete } from "../../List/Actions";
import { formatDate, titlize } from "../utils";
import VersionHistory from "../VersionHistory";

const {
  Menu,
  MenuItem: { Button: MenuButton },
} = Dropdown;

const Header = ({ status, setStatus, isEdit = false }) => {
  const { t } = useTranslation();

  const [isVersionHistoryPaneOpen, setIsVersionHistoryPaneOpen] =
    useState(false);

  const [manageDeleteAlert, setManageDeleteAlert] = useState(
    MANAGE_DELETE_ALERT_INITIAL_VALUE
  );

  const history = useHistory();
  const { id } = useParams();
  const { data: categories = [] } = useFetchCategories();
  const { data: article = {} } = useShowArticle(id);
  const {
    setFieldValue,
    values: { category },
  } = useFormikContext();

  const { isLoading, mutate: createCategory } = useCreateCategory();

  const { status: articleStatus, updated_at: articleUpdatedAt } = article;

  const handleDeleteModalClose = () => {
    setManageDeleteAlert(MANAGE_DELETE_ALERT_INITIAL_VALUE);
    history.push(ARTICLES_URL);
  };

  const handleCreateCategory = category =>
    createCategory(
      { name: category },
      {
        onSuccess: () =>
          setFieldValue("category", { label: category, value: category }),
      }
    );

  const setNewCategory = () => {
    const newCategory = category?.label;
    if (newCategory) {
      setFieldValue("category", {
        label: newCategory,
        value: categories?.find(({ name }) => name === newCategory)?.id,
      });
    }
  };

  useEffect(() => {
    setNewCategory();
  }, [categories]);

  return (
    <div className="flex justify-between px-5">
      <div className="w-64">
        <Select
          isCreateable
          loading={isLoading}
          name="category"
          options={getCategoryOptions(categories)}
          placeholder={t("placeholder.searchCategory")}
          onCreateOption={handleCreateCategory}
        />
      </div>
      <div className="flex items-center space-x-5">
        {isEdit && (
          <Typography className="titlize" style="body2">
            <Trans
              i18nKey="labels.articleSavedDate"
              values={{
                status: titlize(articleStatus),
                date: formatDate(articleUpdatedAt),
              }}
            />
          </Typography>
        )}
        <Button label={t("button.cancel")} style="secondary" type="reset" />
        <SaveButton isEdit={isEdit} setStatus={setStatus} status={status} />
        {isEdit && (
          <Dropdown buttonStyle="text" icon={MenuHorizontal}>
            <Menu>
              <MenuButton onClick={() => setIsVersionHistoryPaneOpen(true)}>
                {t("button.showVersionsHistory")}
              </MenuButton>
              <MenuButton
                style="danger"
                onClick={() => setManageDeleteAlert({ isOpen: true, article })}
              >
                {t("button.delete")}
              </MenuButton>
            </Menu>
          </Dropdown>
        )}
      </div>
      <Delete
        manageDeleteAlert={manageDeleteAlert}
        onClose={handleDeleteModalClose}
      />
      <VersionHistory
        isOpen={isVersionHistoryPaneOpen}
        onClose={() => setIsVersionHistoryPaneOpen(false)}
      />
    </div>
  );
};

export default Header;
