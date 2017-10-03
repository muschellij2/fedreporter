
#' Federal RePORTER projects
#'
#' @param nih_id global identifier for a project across all NIH
#' systems that handle research projects/grants data.
#' Example, 8828294.
#' @param project_number unique number that is assigned to a project
#'  by the affiliated federal agency. Examples: \code{'5R01MH092950-05'},
#'  \code{'1R01CA183929-01A1'}, \code{'USFS-0000779'}.
#' @param internal_id internal Federal RePORTER generated unique ID
#' associated with each project. It is available as part of
#' export on Federal RePORTER search results. Example, 739576.
#' @param secure passed to \code{\link{fe_base_url}} for https
#' @note See \url{https://api.federalreporter.nih.gov/#!/Projects/Get_Project}
#' @param verbose print diagnostic messages
#'
#' @return List of the result of the \code{\link{GET}} call and
#' the content
#' @export
#'
#' @importFrom httr GET
#' @examples
#' res = fe_projects(project_number = "5R01MH092950-05")
fe_projects = function(
  nih_id = NULL,
  internal_id = NULL,
  project_number = NULL,
  verbose = TRUE,
  secure = TRUE) {

  url = fe_base_url(secure = secure)
  path = "/v1/Projects"
  url = paste0(url, path)

  query = list()
  query$smApplId = internal_id
  query$nihApplId = nih_id
  query$projectNumber = project_number

  if (length(query) == 0) {
    query = NULL
    stop("No projects have been specified - must specify one!")
  }
  query = lapply(query, as.character)

  res = httr::GET(url, query = query)
  if (verbose) {
    message("GET command is:")
    print(res)
  }
  httr::stop_for_status(res)
  cr = httr::content(res)

  L = list(
    response = res,
    content = cr)
  return(L)
}
#
# smApplID: It is an
# nihApplId: It is a
# projectNumber: It is a
