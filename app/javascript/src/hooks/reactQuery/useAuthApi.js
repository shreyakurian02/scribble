import { useMutation } from "react-query";

import authApi from "apis/auth";

export const useSignup = options => useMutation(authApi.signup, options);

export const useLogin = options => useMutation(authApi.login, options);

export const useLogout = options => useMutation(authApi.logout, options);
