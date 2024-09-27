export interface Citation {
  paperName: string;
  fullCitation: string;
}

export interface ContextType {
  registerCitation: (names: string[]) => number[];
}
