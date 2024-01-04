import { isEnvBrowser } from "./misc";

export default function inDevelopment() {
  return import.meta.env.MODE === "development" && isEnvBrowser();
}
