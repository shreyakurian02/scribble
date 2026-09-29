import { PLURAL } from "constants";

import { t } from "i18next";
import {
  Notes,
  Settings,
  ExternalLink,
  NeetoAnalytics,
  Left,
} from "neetoicons";

import {
  ARTICLES_URL,
  SETTINGS_URL,
  PREVIEW_URL,
  ANALYTICS_URL,
} from "constants/urls";
import { getFromLocalStorage } from "utils/storage";

export const NAV_LINKS = [
  {
    label: t("common.article", PLURAL),
    to: ARTICLES_URL,
    icon: Notes,
    description: t("sidebarDescription.articles"),
  },
  {
    label: t("common.settings"),
    to: SETTINGS_URL,
    icon: Settings,
    description: t("sidebarDescription.settings"),
  },
  {
    label: t("common.analytics"),
    to: ANALYTICS_URL,
    icon: NeetoAnalytics,
    description: t("sidebarDescription.analytics"),
  },
  {
    label: t("common.preview"),
    to: "#",
    onClick: () => window.open(PREVIEW_URL),
    isActive: () => false,
    icon: ExternalLink,
    description: t("sidebarDescription.preview"),
  },
];

export const SIGN_OUT_LINK = {
  label: t("button.signOut"),
  to: "#",
  isActive: () => false,
  icon: Left,
  description: "",
};

export const getProfileInfo = () => ({
  name: getFromLocalStorage("authUserName"),
  imageUrl: "https://i.pravatar.cc/40",
  email: getFromLocalStorage("authUserEmail"),
});
