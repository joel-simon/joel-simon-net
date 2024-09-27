export interface ProjectData {
  project: {
    completedTemplate: string;
    projectName: string;
    projectDescription: string;
  };
  key: string;
  template: { steps: string[] };
  creatorNames: string[];
}
