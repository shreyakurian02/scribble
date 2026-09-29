import React from "react";

import { EditorContent } from "neetoeditor";
import { Heart } from "neetoicons";
import { Button, Typography } from "neetoui";
import { isEmpty } from "ramda";
import { useTranslation } from "react-i18next";
import { useParams } from "react-router";

import { useShowArticle } from "hooks/reactQuery/public/useArticlesApi";
import {
  useLikeArticle,
  useUnlikeArticle,
} from "hooks/reactQuery/public/useLikesApi";

const Article = () => {
  const { t } = useTranslation();
  const { slug } = useParams();
  const { data: article = {} } = useShowArticle(slug);

  const { mutate: likeArticle, isLoading: isLiking } = useLikeArticle(slug);
  const { mutate: unlikeArticle, isLoading: isUnliking } =
    useUnlikeArticle(slug);

  const { title, description, liked, likes_count: likesCount = 0 } = article;

  const handleLikeToggle = () => (liked ? unlikeArticle() : likeArticle());

  if (isEmpty(article) && !slug) {
    return (
      <div className="flex h-screen w-full items-center justify-center">
        <Typography style="h5">{t("noData.publishedArticles")}</Typography>
      </div>
    );
  }

  return (
    <div className="editor-preview__wrapper w-3/4 space-y-5">
      <Typography style="h1">{title}</Typography>
      <EditorContent content={description} />
      <Button
        aria-label={liked ? t("article.unlike") : t("article.like")}
        aria-pressed={!!liked}
        className={liked ? "text-red-500" : ""}
        disabled={isLiking || isUnliking}
        icon={Heart}
        label={`${likesCount}`}
        style="text"
        onClick={handleLikeToggle}
      />
    </div>
  );
};

export default Article;
