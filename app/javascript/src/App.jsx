import React, { useState, useEffect } from "react";

import { PageLoader } from "neetoui";
import { QueryClientProvider } from "react-query";
import {
  Route,
  Switch,
  Redirect,
  BrowserRouter as Router,
} from "react-router-dom";
import { ToastContainer } from "react-toastify";

import { setAuthHeaders, registerIntercepts } from "apis/axios";
import "common/i18n";
import { initializeLogger } from "common/logger";
import Login from "components/Authentication/Login";
import Signup from "components/Authentication/Signup";
import Dashboard from "components/Dashboard";
import EndUserInterface from "components/EndUserInterface";
import { PREVIEW_URL, ADMIN_URL, LOGIN_URL, SIGNUP_URL } from "constants/urls";
import queryClient from "utils/queryClient";
import { getUserToken } from "utils/storage";

import { DEFAULT_ERROR_VALUES } from "./constants";

const App = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [notFoundError, setNotFoundError] = useState(DEFAULT_ERROR_VALUES);

  useEffect(() => {
    initializeLogger();
    registerIntercepts(setNotFoundError);
    setAuthHeaders(setIsLoading);
  }, []);

  if (isLoading) {
    return (
      <div className="h-screen w-full">
        <PageLoader />
      </div>
    );
  }

  return (
    <QueryClientProvider client={queryClient}>
      <Router>
        <ToastContainer />
        <Switch>
          <Route exact component={Login} path={LOGIN_URL} />
          <Route exact component={Signup} path={SIGNUP_URL} />
          <Route
            path={ADMIN_URL}
            render={() =>
              getUserToken() ? (
                <Dashboard
                  notFoundError={notFoundError}
                  setNotFoundError={setNotFoundError}
                />
              ) : (
                <Redirect to={LOGIN_URL} />
              )
            }
          />
          <Route
            path={PREVIEW_URL}
            render={() => (
              <EndUserInterface
                notFoundError={notFoundError}
                setNotFoundError={setNotFoundError}
              />
            )}
          />
        </Switch>
      </Router>
    </QueryClientProvider>
  );
};

export default App;
