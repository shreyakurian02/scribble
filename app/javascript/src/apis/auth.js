import axios from "axios";

import { SIGNUP_API_URL, USER_SESSION_URL } from "constants/routes";

const signup = params => axios.post(SIGNUP_API_URL, { user: params });

const login = params => axios.post(USER_SESSION_URL, { login: params });

const logout = () => axios.delete(USER_SESSION_URL);

const authApi = { signup, login, logout };

export default authApi;
