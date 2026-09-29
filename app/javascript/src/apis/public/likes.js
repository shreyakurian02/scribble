import axios from "axios";

import { PUBLIC_ARTICLES_BASE_URL } from "constants/routes";

const likeUrl = slug => `${PUBLIC_ARTICLES_BASE_URL}/${slug}/like`;

const create = slug => axios.post(likeUrl(slug));

const destroy = slug => axios.delete(likeUrl(slug));

const likesApi = { create, destroy };

export default likesApi;
