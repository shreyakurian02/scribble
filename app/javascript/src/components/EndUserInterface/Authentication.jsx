import React from "react";

import { Button, Typography } from "neetoui";
import { Form, Input } from "neetoui/formik";
import { useTranslation } from "react-i18next";

import { setAuthHeaders } from "apis/axios";
import { PREVIEW_URL } from "constants/urls";
import { useCreateSession } from "hooks/reactQuery/public/useSessionApi";
import { setToLocalStorage } from "utils/storage";

import { LOGIN_INTIAL_VALUES, LOGIN_VALIDATION_SCHEMA } from "./constants";

const Authentication = ({ site }) => {
  const { t } = useTranslation();

  const { title } = site;

  const onSuccess = ({ data = {} }) => {
    setToLocalStorage({ key: "authToken", value: data.authentication_token });
    setAuthHeaders();
    window.location.href = PREVIEW_URL;
  };

  const { isLoading, mutate: createSession } = useCreateSession({ onSuccess });

  const handleSubmit = ({ password }, { setSubmitting }) =>
    createSession({ password }, { onSettled: () => setSubmitting(false) });

  return (
    <div className="flex h-screen flex-col items-center justify-center">
      <div className="w-1/3">
        <Typography style="h2">
          {t("headers.siteProtected", { site: title })}
        </Typography>
        <Typography className="neeto-ui-text-gray-500" style="body1">
          {t("headers.enterPassword", { site: title })}
        </Typography>
        <Form
          formikProps={{
            initialValues: LOGIN_INTIAL_VALUES,
            validationSchema: LOGIN_VALIDATION_SCHEMA,
            onSubmit: handleSubmit,
          }}
        >
          {({ isSubmitting }) => (
            <div className="mt-3 space-y-5 text-center">
              <Input
                required
                label={t("input.password")}
                name="password"
                placeholder={t("placeholder.enterPassword")}
                type="password"
              />
              <Button
                fullWidth
                disabled={isSubmitting || isLoading}
                label={t("button.continue")}
                loading={isLoading}
                type="submit"
              />
            </div>
          )}
        </Form>
      </div>
    </div>
  );
};

export default Authentication;
