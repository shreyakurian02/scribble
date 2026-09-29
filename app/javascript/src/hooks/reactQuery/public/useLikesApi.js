import { useMutation, useQueryClient } from "react-query";
import { QUERY_KEYS } from "src/constants/query";

import likesApi from "apis/public/likes";

const { PUBLIC_ARTICLE } = QUERY_KEYS;

// The cached value is the raw axios response, so patch the article inside it.
const patchArticle = (cached, changes) =>
  cached && {
    ...cached,
    data: { ...cached.data, article: { ...cached.data.article, ...changes } },
  };

// Toggling a like must not refetch the article: every show request bumps its
// view count. Instead, the cache is updated optimistically and then reconciled
// with the counts returned by the like endpoints.
const useToggleLike = (slug, request, liked) => {
  const queryClient = useQueryClient();
  const queryKey = [PUBLIC_ARTICLE, slug];

  return useMutation(() => request(slug), {
    onMutate: async () => {
      await queryClient.cancelQueries(queryKey);
      const previous = queryClient.getQueryData(queryKey);
      const likesCount = previous?.data?.article?.likes_count ?? 0;
      queryClient.setQueryData(queryKey, cached =>
        patchArticle(cached, {
          liked,
          likes_count: Math.max(likesCount + (liked ? 1 : -1), 0),
        })
      );

      return { previous };
    },
    onError: (_error, _variables, context) =>
      queryClient.setQueryData(queryKey, context?.previous),
    onSuccess: ({ data }) =>
      queryClient.setQueryData(queryKey, cached =>
        patchArticle(cached, data.like)
      ),
  });
};

export const useLikeArticle = slug =>
  useToggleLike(slug, likesApi.create, true);

export const useUnlikeArticle = slug =>
  useToggleLike(slug, likesApi.destroy, false);
