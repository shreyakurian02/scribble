import React from "react";

import { Input, Button } from "neetoui";
import { useTranslation } from "react-i18next";

import Form from "./Form";

const Password = ({
  isSitePasswordProtected,
  setIsChangePasswordEnabled,
  isChangePasswordEnabled,
}) => {
  const { t } = useTranslation();

  if (isChangePasswordEnabled || !isSitePasswordProtected) {
    return <Form setIsChangePasswordEnabled={setIsChangePasswordEnabled} />;
  }

  return (
    <div className="space-y-5">
      <Input
        disabled
        className="w-3/4"
        label={t("input.password")}
        placeholder="******"
        type="password"
      />
      <Button
        label={t("button.changePassword")}
        onClick={() => setIsChangePasswordEnabled(true)}
      />
    </div>
  );
};

export default Password;
