# context ------------------------------------------------------------
context(desc = "ggscatterstats")

# pearson's r with NAs ---------------------------------------------

testthat::test_that(
  desc = "checking ggscatterstats - without NAs - pearson's r",
  code = {
    # creating the plot
    set.seed(123)
    p <-
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = bodywt,
        label.var = "name",
        label.expression = bodywt > 2000,
        xlab = "sleep (total)",
        ylab = "body weight",
        type = "p",
        messages = TRUE,
        centrality.para = "mean",
        marginal = FALSE,
        bf.message = TRUE,
        caption = "ggplot2 dataset",
        title = "Mammalian sleep",
        xfill = NULL,
        package = "wesanderson",
        palette = "BottleRocket1"
      )

    # plot build
    pb <- ggplot2::ggplot_build(p)

    # checking data used to create a plot
    dat <- tibble::as_tibble(p$data) %>%
      dplyr::mutate_if(
        .tbl = .,
        .predicate = is.factor,
        .funs = ~ as.character(.)
      )

    # checking dimensions of data
    data_dims <- dim(dat)
    ggrepel_dims <- dim(p$plot_env$label_data)

    # testing everything is okay with imported and ggrepel data
    testthat::expect_equal(data_dims, c(83L, 13L))
    testthat::expect_equal(
      ggrepel_dims[1],
      dim(dplyr::filter(ggplot2::msleep, bodywt > 2000))[1]
    )
    testthat::expect_equal(ggrepel_dims[2], 13L)

    # checking layer data
    testthat::expect_equal(length(pb$data), 7L)
    testthat::expect_equal(dim(pb$data[[1]]), c(83L, 10L))
    testthat::expect_equal(dim(pb$data[[2]]), c(80L, 13L))
    testthat::expect_equal(dim(pb$data[[3]]), c(1L, 7L))
    testthat::expect_equal(dim(pb$data[[4]]), c(1L, 7L))
    testthat::expect_equal(dim(pb$data[[5]]), c(83L, 15L))
    testthat::expect_equal(dim(pb$data[[6]]), c(83L, 15L))
    testthat::expect_equal(dim(pb$data[[7]]), c(2L, 15L))

    # checking intercepts
    testthat::expect_equal(pb$data[[3]]$xintercept, 10.43373, tolerance = 0.001)
    testthat::expect_equal(pb$data[[4]]$yintercept, 166.1363, tolerance = 0.001)
    testthat::expect_equal(pb$data[[3]]$colour, "#A42820")
    testthat::expect_equal(pb$data[[4]]$colour, "#5F5647")

    # check labels
    testthat::expect_equal(p$plot_env$x_label_pos, 10.88401, tolerance = 0.002)
    testthat::expect_equal(p$plot_env$x_median, 10.1000, tolerance = 0.002)
    testthat::expect_equal(p$plot_env$x_mean, 10.43373, tolerance = 0.002)
    testthat::expect_equal(p$plot_env$y_label_pos, 2954.955, tolerance = 0.002)
    testthat::expect_equal(p$plot_env$y_median, 1.6700, tolerance = 0.002)
    testthat::expect_equal(p$plot_env$y_mean, 166.1363, tolerance = 0.002)

    # subtitle
    set.seed(123)
    p_subtitle <- ggstatsplot::subtitle_ggscatterstats(
      data = ggplot2::msleep,
      x = sleep_total,
      y = bodywt,
      type = "p",
      messages = FALSE
    )

    # checking plot labels
    testthat::expect_identical(
      p$plot_env$caption,
      ggplot2::expr(atop(
        displaystyle("ggplot2 dataset"),
        expr = paste(
          "In favor of null: ",
          "log"["e"],
          "(BF"["01"],
          ") = ",
          "-2.23",
          ", Prior width = ",
          "0.71"
        )
      ))
    )
    testthat::expect_identical(p$plot_env$title, "Mammalian sleep")
    testthat::expect_identical(p$plot_env$subtitle, p_subtitle)
    testthat::expect_identical(pb$plot$labels$x, "sleep (total)")
    testthat::expect_identical(pb$plot$labels$y, "body weight")
    testthat::expect_identical(
      pb$data[[7]]$label,
      c("Asian elephant", "African elephant")
    )
  }
)

# spearman's rho with NAs ---------------------------------------------

testthat::test_that(
  desc = "checking ggscatterstats - without NAs - spearman's rho",
  code = {
    # creating the plot
    set.seed(123)
    p <-
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = bodywt,
        type = "np",
        conf.level = 0.99,
        marginal = FALSE,
        messages = FALSE
      )

    # subtitle
    set.seed(123)
    p_subtitle <- ggstatsplot::subtitle_ggscatterstats(
      data = ggplot2::msleep,
      x = sleep_total,
      y = bodywt,
      type = "np",
      conf.level = 0.99,
      messages = FALSE
    )

    testthat::expect_identical(p$plot_env$subtitle, p_subtitle)
  }
)


# percentage bend with NAs ---------------------------------------------

testthat::test_that(
  desc = "checking ggscatterstats - without NAs - percentage bend",
  code = {
    # creating the plot
    set.seed(123)
    p <-
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = bodywt,
        type = "r",
        centrality.para = "mean",
        conf.level = 0.90,
        marginal = FALSE,
        messages = FALSE
      )

    # subtitle
    set.seed(123)
    p_subtitle <- ggstatsplot::subtitle_ggscatterstats(
      data = ggplot2::msleep,
      x = sleep_total,
      y = bodywt,
      type = "r",
      conf.level = 0.90,
      messages = FALSE
    )

    # built plot
    pb <- ggplot2::ggplot_build(p)

    testthat::expect_identical(p$plot_env$subtitle, p_subtitle)

    testthat::expect_equal(pb$data[[3]]$xintercept[[1]],
      mean(ggplot2::msleep$sleep_total, na.rm = TRUE),
      tolerance = 1e-3
    )
    testthat::expect_equal(pb$data[[4]]$yintercept[[1]],
      mean(ggplot2::msleep$bodywt, na.rm = TRUE),
      tolerance = 1e-3
    )
  }
)


# checking median display ---------------------------------------------

testthat::test_that(
  desc = "checking median display",
  code = {
    # creating the plot
    set.seed(123)

    # plot
    p <-
      suppressMessages(ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_cycle,
        y = awake,
        xfill = NULL,
        palette = "Royal1",
        package = "wesanderson",
        marginal = FALSE,
        centrality.para = "median",
        axes.range.restrict = TRUE,
        messages = FALSE
      ))

    # built plot
    pb <- ggplot2::ggplot_build(p)

    # checking intercepts
    testthat::expect_equal(pb$plot$plot_env$x_label_pos,
      0.8066451,
      tolerance = 1e-3
    )
    testthat::expect_equal(pb$plot$plot_env$y_label_pos,
      13.37923,
      tolerance = 1e-3
    )
    testthat::expect_equal(pb$data[[3]]$xintercept[[1]],
      median(ggplot2::msleep$sleep_cycle, na.rm = TRUE),
      tolerance = 1e-3
    )
    testthat::expect_equal(pb$data[[4]]$yintercept[[1]],
      median(ggplot2::msleep$awake, na.rm = TRUE),
      tolerance = 1e-3
    )

    # checking panel parameters
    testthat::expect_equal(pb$layout$panel_params[[1]]$x.range,
      c(0.0405715, 1.5722818),
      tolerance = 0.001
    )
    testthat::expect_identical(
      pb$layout$panel_params[[1]]$x.labels,
      c("0.4", "0.8", "1.2")
    )
    testthat::expect_equal(pb$layout$panel_params[[1]]$y.range,
      c(3.25, 21.95),
      tolerance = 0.001
    )
    testthat::expect_identical(
      as.character(pb$layout$panel_params[[1]]$y.labels),
      c("5", "10", "15", "20")
    )
  }
)

# bayes factor plus class of object -----------------------------------------

testthat::test_that(
  desc = "bayes factor plus class of object",
  code = {
    # creating the plot
    set.seed(123)
    p <-
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = bodywt,
        xlab = "total sleep",
        ylab = "body weight",
        title = "mammalian sleep dataset",
        caption = "source: ggplot2 package",
        type = "bf",
        messages = FALSE
      )

    # subtitle
    p_subtitle <- ggstatsplot::subtitle_ggscatterstats(
      data = ggplot2::msleep,
      x = sleep_total,
      y = bodywt,
      type = "bf",
      messages = FALSE
    )

    testthat::expect_identical(class(p)[[1]], "ggExtraPlot")
    testthat::expect_identical(
      tibble::enframe(p$grobs[[23]]$children)$value[[1]][[1]],
      "mammalian sleep dataset"
    )
    testthat::expect_identical(
      tibble::enframe(p$grobs[[17]]$children)$value[[1]][[1]],
      "source: ggplot2 package"
    )
    testthat::expect_identical(
      tibble::enframe(p$grobs[[12]]$children)$value[[1]][[1]],
      "total sleep"
    )
    testthat::expect_identical(
      tibble::enframe(p$grobs[[13]]$children)$value[[1]][[1]],
      "body weight"
    )
    testthat::expect_identical(
      tibble::enframe(p$grobs[[22]]$children)$value[[1]][[1]],
      p_subtitle
    )
  }
)

# aesthetic modifications work ---------------------------------------------

testthat::test_that(
  desc = "aesthetic modifications work",
  code = {
    # creating the plot
    set.seed(123)
    p <- ggstatsplot::ggscatterstats(
      data = ggplot2::msleep,
      x = sleep_total,
      y = sleep_cycle,
      label.expression = "sleep_total > 17",
      label.var = "order",
      results.subtitle = FALSE,
      marginal = FALSE,
      messages = TRUE
    ) +
      ggplot2::coord_cartesian(ylim = c(0, 7000)) +
      ggplot2::scale_y_continuous(breaks = seq(0, 7000, 1000))

    # build the plot
    pb <- ggplot2::ggplot_build(p)

    testthat::expect_identical(
      pb$layout$panel_params[[1]]$y.labels,
      c("0", "1000", "2000", "3000", "4000", "5000", "6000", "7000")
    )

    # both quoted
    testthat::expect_true(inherits(p, what = "gg"))
  }
)

# labeling input variations ---------------------------------------------

testthat::test_that(
  desc = "checking ggscatterstats with different kinds of inputs to labeling",
  code = {
    testthat::skip_on_cran()

    # both quoted
    testthat::expect_true(inherits(
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = sleep_cycle,
        label.expression = "sleep_total > 17",
        label.var = "order",
        results.subtitle = FALSE,
        marginal = FALSE,
        messages = TRUE
      ),
      what = "gg"
    ))

    # both unquoted
    testthat::expect_true(inherits(
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = sleep_cycle,
        label.expression = sleep_total > 17,
        label.var = order,
        results.subtitle = FALSE,
        marginal = FALSE,
        messages = TRUE
      ),
      what = "gg"
    ))

    # one unquoted, one quoted
    testthat::expect_true(inherits(
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = sleep_cycle,
        label.expression = sleep_total > 17,
        label.var = "order",
        results.subtitle = FALSE,
        marginal = FALSE,
        messages = TRUE
      ),
      what = "gg"
    ))

    # one unquoted, one quoted
    testthat::expect_true(inherits(
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = sleep_cycle,
        label.expression = "sleep_total > 17",
        label.var = order,
        results.subtitle = FALSE,
        marginal = FALSE,
        messages = TRUE
      ),
      what = "gg"
    ))
  }
)

# with marginals ----------------------------------------------------------

testthat::test_that(
  desc = "with marginals",
  code = {
    # creating the plot
    set.seed(123)
    p <-
      ggstatsplot::ggscatterstats(
        data = ggplot2::msleep,
        x = sleep_total,
        y = bodywt,
        messages = TRUE
      )

    testthat::expect_identical(
      class(p),
      c("ggExtraPlot", "gtable", "gTree", "grob", "gDesc")
    )
  }
)

# message checks ----------------------------------------------------------

testthat::test_that(
  desc = "class of object",
  code = {
    # creating the messages
    set.seed(123)
    p_message1 <- capture.output(
      ggstatsplot::subtitle_ggscatterstats(
        data = dplyr::starwars,
        x = mass,
        y = height,
        conf.level = 0.50,
        nboot = 10,
        type = "np"
      )
    )

    p_message2 <- capture.output(
      ggstatsplot::subtitle_ggscatterstats(
        data = dplyr::starwars,
        x = mass,
        y = height,
        conf.level = 0.90,
        nboot = 15,
        type = "r"
      )
    )

    # checking captured messages
    testthat::expect_match(p_message1[1],
      "50% CI for effect size estimate was computed with 10",
      fixed = TRUE
    )

    testthat::expect_match(p_message2[1],
      "90% CI for effect size estimate was computed with 15",
      fixed = TRUE
    )
  }
)
