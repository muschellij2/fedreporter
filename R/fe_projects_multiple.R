#' Fetch multiple projects by internal Federal RePORTER IDs (SM ID
#' or Project Numbers)
#'
#' @param internal_id internal Federal 'RePORTER' generated unique ID
#' associated with each project. It is available as part of
#' export on Federal RePORTER search results. Example, 739576.
#' @param project_number unique number that is assigned to a project
#'  by the affiliated federal agency. Examples: \code{'5R01MH092950-05'},
#'  \code{'1R01CA183929-01A1'}, \code{'USFS-0000779'}.
#' @param secure passed to \code{\link{fe_base_url}} for https
#' @note See
#' \url{https://api.federalreporter.nih.gov/#!/Projects/Get_Project},
#' this calls \code{POST /v1/projects/FetchBySmApplIds}
#'
#' @return List of the result of the \code{\link{GET}} call and
#' the content
#' @export
#' @importFrom httr POST stop_for_status content content_type_json
#' @importFrom jsonlite toJSON
#' @examples
#' res = fe_projects_multiple(
#' project_number = c("5R01MH092950-05", "USFS-0000779")
#' )
#' res = fe_projects_multiple(
#' internal_id = c("739576", "739577")
#' )
fe_projects_multiple = function(
  internal_id = NULL,
  project_number = NULL,
  secure = TRUE) {

  url = fe_base_url(secure = secure)
  if (is.null(internal_id) && is.null(project_number)) {
    stop("Internal IDs or Project Numbers must be specified!")
  }
  if (!is.null(internal_id) && is.null(project_number)) {
    fetch_by = "SmApplIds"
    body = internal_id
  }
  if (is.null(internal_id) && !is.null(project_number)) {
    fetch_by = "ProjectNumbers"
    body = project_number
  }

  path = paste0("/v1/Projects/", "FetchBy", fetch_by)
  url = paste0(url, path)

  # if (length(query) == 0) {
  #   query = NULL
  #   stop("No projects have been specified - must specify one!")
  # }
  # query = lapply(query, function(x) {
    # jsonlite::toJSON(x)
  # })
  body = jsonlite::toJSON(body)

  res = httr::POST(url, body = body, httr::content_type_json())
  httr::stop_for_status(res)
  cr = httr::content(res)

  L = list(
    response = res,
    content = cr)
  return(L)
}
