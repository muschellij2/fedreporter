#' Search Federal RePORTER Projects
#'
#' @param project_number unique number that is assigned to a project
#'  by the affiliated federal agency. Examples, 5R01MH092950-05,
#'  1R01CA183929-01A1, USFS-0000779.
#'  Can also use wildcards such as \code{*R01*}.
#' @param fiscal_year Fiscal year of data to obtain
#' @param text Search text from title, abstract, and terms data
#' @param text_field text field to search, can be title, abstract or terms,
#' and defaults to search all. Only enabled when \code{text} is not \code{NULL}.
#' @param text_operator Text operator to combine text terms,
#' Can be AND or OR, AND is default.
#' Only enabled when \code{text} is not \code{NULL}.
#' @param agency Agency code to search.  see \code{\link{fe_agencies}}
#' @param pi_name Principal investigator name.  Names are to be in the
#' \code{Last First M}, \code{Last, First}, \code{First},
#' \code{Last}, or \code{First Last} formats.  Multiple names can be
#' given.
#' @param offset start at item # (starts at 1)
#' @param limit max # of items to return (at the most 50 per request)
#' @param secure Should https be used, passed to \code{\link{fe_base_url}}
#' @param verbose print diagnostic messages
#'
#' @return List of the result of the \code{\link{GET}} call and
#' the content
#' @export
#'
#' @examples
#' res = fe_projects_search(
#' project_number = "USFS*",
#' fiscal_year = 2012)
#' res = fe_projects_search(
#' project_number = "*R01*",
#' fiscal_year = 2012,
#' agency = "NIH",
#' text = "stroke",
#' text_field = "title")
#'
#' \dontrun{
#' res = fe_projects_search(pi_name = "MATSUI, ELIZABETH")
#' items = res$content$items
#' con_pis = sapply(items, "[[", "contactPi")
#' keep = grepl("^MATSUI", con_pis)
#' items = items[keep]
#' mat_costs = sapply(items, "[[", "totalCostAmount")
#' sum(mat_costs)
#'
#' res = fe_projects_search(pi_name = "PENG, ROGER")
#' items = res$content$items
#' con_pis = sapply(items, "[[", "contactPi")
#' keep = grepl("^PENG", con_pis)
#' items = items[keep]
#' peng_costs = sapply(items, "[[", "totalCostAmount")
#' sum(peng_costs)
#'
#' both = fe_projects_search(
#' pi_name = c("MATSUI, ELIZABETH", "PENG, ROGER"))
#' }
fe_projects_search = function(
  project_number = NULL,
  fiscal_year = NULL,
  text = NULL,
  text_field = c("title", "abstract", "terms"),
  text_operator = c("AND", "OR"),
  agency = NULL,
  pi_name = NULL,
  offset = 1,
  limit = 50,
  verbose = TRUE,
  secure = TRUE
){

  url = fe_base_url(secure = secure)
  path = "/v1/Projects/search"
  url = paste0(url, path)

  query = list()


  # projectNumber
  if (!is.null(project_number)) {
    project_number = paste(project_number, collapse = ",")
    query$projectNumber = project_number
  }

  # fy
  if (!is.null(fiscal_year)) {
    fiscal_year = as.integer(fiscal_year)
    fiscal_year = paste(fiscal_year, collapse = ",")
    query$fy = fiscal_year
  }

  # agency
  if (!is.null(agency)) {
    fields = fedreporter::fe_agencies
    agency = match.arg(agency, choices = fields, several.ok = TRUE)
    agency = paste(agency, collapse = ",")
    query$agency = agency
  }

  # text
  if (!is.null(text)) {
    text = paste(text, collapse = " ")
    query$text = text

    # textFields
    if (!is.null(text_field)) {
      fields = c("title", "abstract", "terms")
      text_field = match.arg(text_field, choices = fields, several.ok = TRUE)
      text_field = paste(text_field, collapse = ",")
      query$textFields = text_field
    }

    # textOperator:AND
    if (!is.null(text_operator)) {
      text_operator = match.arg(text_operator)
      query$textOperator = text_operator
    }
  }

  # piName
  if (!is.null(pi_name)) {
    pi_name = paste(pi_name, collapse = ";")
    pi_name = toupper(pi_name)
    query$piName = pi_name
  }

  if (length(query) == 0) {
    stop("query has no search terms!")
  }
  nquery = names(query)
  query = mapply(function(x, n) {
    paste0(n, ":", x)
  }, query, nquery, SIMPLIFY = TRUE)
  query = paste(query, collapse = "$")
  query = gsub(":", "%3A", query)
  query = gsub("$", "%24", query, fixed = TRUE)
  query = gsub(" ", "%20", query)
  query = gsub(",", "%2C", query)


  query = list(
    query = I(query)
    )
  query$offset = offset
  query$limit = limit

  # new_url <- httr::parse_url(url)
  # new_url$query = query
  # new_url$query$query =  I(new_url$query$query)
  # new_url = httr::build_url(new_url)
  # new_url = gsub("%2A", "*", new_url)
  # new_url = gsub("%2C", ",", new_url)
  # new_url = gsub("%24", "$", new_url)
  # new_url = gsub(":", "%3A", new_url)
  # print(new_url)
  # res = httr::GET(new_url, httr::accept_json())


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
