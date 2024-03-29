import React, { useState } from "react";

import { Search, Plus } from "neetoicons";
import { Typography } from "neetoui";
import { MenuBar as NeetoUIMenuBar } from "neetoui/layouts";
import { isEmpty } from "ramda";
import { useTranslation } from "react-i18next";
import { useHistory } from "react-router";
import { PLURAL } from "src/constants";
import { v4 as uuid } from "uuid";

import { useFetchCategories } from "hooks/reactQuery/useCategoriesApi";
import useDebounce from "hooks/useDebounce";

import { STATUS_MENU_BLOCKS } from "./constants";
import {
  pushUrlSearchParams,
  getQueryParams,
  handleFilterByCategories,
} from "./utils";

import { DEFAULT_PAGE_PROPERTIES } from "../constants";

const { Block, SubTitle, Search: MenuSearch } = NeetoUIMenuBar;

const MenuBar = ({
  articlesCount,
  showMenu,
  setIsNewCategoryModalOpen,
  setPageProperties,
}) => {
  const { t } = useTranslation();

  const [isSearchCollapsed, setIsSearchCollapsed] = useState(true);
  const [categorySearchTerm, setCategorySearchTerm] = useState("");

  const history = useHistory();
  const debouncedCategorySearchTerm = useDebounce(categorySearchTerm);
  const { data: categories = [] } = useFetchCategories({
    search: debouncedCategorySearchTerm,
  });

  const isSearchedCategoryResultEmpty =
    isEmpty(categories) && !isEmpty(debouncedCategorySearchTerm);

  const { status, categories: queryCategories } = getQueryParams();

  const handleAddCategory = () => setIsNewCategoryModalOpen(true);

  const handleSearchCollapse = () =>
    setIsSearchCollapsed(isSearchCollapsed => !isSearchCollapsed);

  const handleCollapse = () => {
    setCategorySearchTerm("");
    setIsSearchCollapsed(true);
  };

  const handleCategorySelect = selectedCategory => {
    setPageProperties(DEFAULT_PAGE_PROPERTIES);
    handleFilterByCategories({
      queryCategories,
      history,
      selectedCategory,
    });
  };

  const handleEsc = ({ keyCode }) => keyCode === 27 && handleCollapse();

  return (
    <NeetoUIMenuBar showMenu={showMenu} title={t("common.article", PLURAL)}>
      {STATUS_MENU_BLOCKS.map(({ label, value }) => (
        <Block
          active={status === value}
          count={articlesCount[value]}
          key={uuid()}
          label={label}
          onClick={() =>
            pushUrlSearchParams({ history, param: "status", value })
          }
        />
      ))}
      <SubTitle
        iconProps={[
          { icon: Search, onClick: handleSearchCollapse },
          { icon: Plus, onClick: handleAddCategory },
        ]}
      >
        <Typography style="h5" textTransform="uppercase" weight="bold">
          {t("common.category", PLURAL)}
        </Typography>
      </SubTitle>
      <MenuSearch
        autoFocus
        collapse={isSearchCollapsed}
        placeholder={t("placeholder.searchCategory")}
        value={categorySearchTerm}
        onChange={({ target: { value } }) => setCategorySearchTerm(value)}
        onCollapse={handleCollapse}
        onKeyDown={handleEsc}
      />
      {isSearchedCategoryResultEmpty ? (
        <Typography style="body2">{t("noData.categories")}</Typography>
      ) : (
        categories?.map(({ name, id, articles_count: articlesCount }) => (
          <Block
            active={queryCategories?.includes(name)}
            count={articlesCount}
            key={id}
            label={name}
            onClick={() => handleCategorySelect(name)}
          />
        ))
      )}
    </NeetoUIMenuBar>
  );
};

export default MenuBar;
