import { DEFAULT_ERROR_NOTIFICATION } from "constants";

import axios from "axios";
import { Toastr } from "neetoui";

import { getFromLocalStorage, getVisitorToken } from "../utils/storage";

axios.defaults.baseURL = "/";

const setAuthHeaders = (setIsLoading = () => null) => {
  axios.defaults.headers = {
    Accept: "application/json",
    "Content-Type": "application/json",
    "X-CSRF-TOKEN": document
      .querySelector('[name="csrf-token"]')
      .getAttribute("content"),
    "X-Visitor-Token": getVisitorToken(),
  };
  const token = getFromLocalStorage("authToken");
  if (token) {
    axios.defaults.headers["X-Auth-Token"] = token;
  }
  setIsLoading(false);
};

const handleSuccessResponse = response => {
  if (response) {
    response.success = response.status === 200;
    if (response.data.notice) {
      Toastr.success(response.data.notice);
    }
  }

  return response;
};

const handleErrorResponse = (axiosErrorObject, setNotFoundError) => {
  const errorMessage = axiosErrorObject.response?.data?.error;
  const errorStatus = axiosErrorObject.response?.status;

  if (errorStatus === 404) {
    setNotFoundError({
      show: true,
      message: errorMessage,
    });
  } else {
    Toastr.error(errorMessage || DEFAULT_ERROR_NOTIFICATION);
  }

  if (errorStatus === 401) {
    localStorage.removeItem("authToken");
  } else if (errorStatus === 423) {
    window.location.href = "/";
  }

  return Promise.reject(axiosErrorObject);
};

const registerIntercepts = setNotFoundError => {
  axios.interceptors.response.use(handleSuccessResponse, error =>
    handleErrorResponse(error, setNotFoundError)
  );
};

export { setAuthHeaders, registerIntercepts };
