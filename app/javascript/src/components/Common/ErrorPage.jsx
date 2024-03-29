import React from "react";

import { Typography, Button } from "neetoui";
import PropTypes from "prop-types";
import { useTranslation } from "react-i18next";
import { DEFAULT_ERROR_VALUES } from "src/constants";
import { noop } from "src/utils";

const ErrorPage = ({
  notFoundError = {},
  homeUrl = "",
  setNotFoundError = noop,
}) => {
  const { t } = useTranslation();

  const { message = t("errors.pageNotFound") } = notFoundError;

  return (
    <div className="flex h-screen w-full flex-col items-center justify-center space-y-2">
      <Typography style="h2">{message}</Typography>
      <Button
        label={t("button.goHome")}
        to={homeUrl}
        onClick={() => setNotFoundError(DEFAULT_ERROR_VALUES)}
      />
    </div>
  );
};

ErrorPage.propTypes = {
  notFoundError: PropTypes.object,
  homeUrl: PropTypes.string,
  setNotFoundError: PropTypes.func,
};

export default ErrorPage;
