import React, { useState, useEffect } from "react";

import { Typography } from "neetoui";
import { isEmpty } from "ramda";
import { useHistory } from "react-router";

import categoriesApi from "apis/public/categories";

import AccordianItem from "./AccordianItem";
import Article from "./Article";

const Preview = ({ site }) => {
  const [categories, setCategories] = useState([]);
  const [article, setArticle] = useState({});

  const history = useHistory();

  const { title } = site;

  const fetchCategories = async () => {
    try {
      const {
        data: { categories },
      } = await categoriesApi.fetch();
      setCategories(categories);

      const firstCategoryWithArticles = categories.find(
        category => !isEmpty(category.articles)
      );

      if (firstCategoryWithArticles) {
        history.push(`/public/${firstCategoryWithArticles.articles[0].slug}`);
      }
    } catch (error) {
      logger.error(error);
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  return (
    <>
      <div className="border-b sticky z-10 flex h-16 w-full items-center justify-center px-6 py-4">
        <Typography className="neeto-ui-text-gray-800" style="h4">
          {title}
        </Typography>
      </div>
      <div className="flex w-full">
        <div className="border-r accodrian_container w-1/4">
          {categories.map(category => (
            <AccordianItem
              category={category}
              isCategoryExpanded={article.category_id === category.id}
              key={category.id}
            />
          ))}
        </div>
        <Article article={article} setArticle={setArticle} />
      </div>
    </>
  );
};

export default Preview;
