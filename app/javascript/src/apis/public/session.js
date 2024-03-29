import axios from "axios";

import { SESSIONS_BASE_URL } from "constants/routes";

const login = params => axios.post(SESSIONS_BASE_URL, { login: params });

const sessionApi = { login };

export default sessionApi;
