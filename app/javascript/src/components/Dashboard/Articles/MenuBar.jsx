import { PLURAL } from "constants";

import React, { useState } from "react";

import { Search, Plus } from "neetoicons";
import { Typography } from "neetoui";
import { MenuBar as NeetoUIMenuBar } from "neetoui/layouts";
import { isEmpty } from "ramda";
import { useTranslation } from "react-i18next";
import { useHistory } from "react-router";
import { v4 as uuid } from "uuid";

import { useCategoriesState } from "contexts/categories";

import { STATUS_MENU_BLOCKS } from "./constants";
import {
  pushURLSearchParams,
  getSearchParams,
  handleFilterByCategories,
} from "./utils";

const { Block, SubTitle, Search: MenuSearch } = NeetoUIMenuBar;

const MenuBar = ({
  articlesCount,
  setCategorySearchTerm,
  categorySearchTerm,
  showMenu,
  setIsNewCategoryModalOpen,
}) => {
  const [isSearchCollapsed, setIsSearchCollapsed] = useState(true);

  const { t } = useTranslation();
  const history = useHistory();
  const categories = useCategoriesState();

  const { status, categories: queryCategories } = getSearchParams();

  const isSearchedCategoryResultEmpty =
    isEmpty(categories) && !isEmpty(categorySearchTerm);

  const handleAddCategory = () =>
    setIsNewCategoryModalOpen(isModalOpen => !isModalOpen);

  const handleSearchCollapse = () =>
    setIsSearchCollapsed(isSearchCollapsed => !isSearchCollapsed);

  const handleCollapse = () => {
    setCategorySearchTerm("");
    setIsSearchCollapsed(true);
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
            pushURLSearchParams({ history, param: "status", value })
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
            onClick={() =>
              handleFilterByCategories({
                queryCategories,
                history,
                selectedCategory: name,
              })
            }
          />
        ))
      )}
    </NeetoUIMenuBar>
  );
};

export default MenuBar;
