function run(img_path, point_cloud_flag, output_folder)

    total_tic = tic;
    %% Step 1: Obtain outlines of the object
    fprintf('\nStep 1: Obtaining outlines of the object...\n');
    % Background Removal
    [mask_path, img_name] = remove_background(img_path, output_folder);

    % Image Preparation
    [img, no_bg_img, reference_img, symmetry_angle, mask2, lx, ly,...
        rx, ry, top_point, R] = prepare_image(img_path, mask_path);


    %% Step 2: Find the 3D symmetry plane
    fprintf('\nStep 2: Finding the 3D symmetry plane...\n');
    [y, n, Pbase, p1, f, K, dh, top_point, bot_point] = initialize_parameters(...
        lx, ly, rx, ry, top_point, R, no_bg_img);


    %% Step 3: Compute the precise axis of revolution
    fprintf('\nStep 3: Computing the precise axis of revolution...\n');
    % Finding Best Angle of the Main Axis
    [best_angle, best_loss] = compute_best_angle(n, reference_img, Pbase, K, ...
        p1, dh, top_point, bot_point, f, R, y, mask2, symmetry_angle);

    fprintf('Best angle found: %.3f degrees\n', best_angle);


    %% Step 4: Optimizing Focal Length
    fprintf('\nStep 4: Optimizing focal length...\n');
    [f, K, dh, x, y, n, Pbase, p1, top_point, bot_point] = optimize_focal_length(...
        reference_img, K, dh, top_point, R, best_angle, lx, ly, rx, ry, mask2, f, ...
        best_loss, symmetry_angle);

    fprintf('Optimized focal length: %.1f\n', f);


    %% Step 5: Generate the 3D textured model
    fprintf('\nStep 5: Generating the 3D textured model...\n');
    % Fitting Ellipses and Reconstructing 3D Dome
    [surface_patterns, profile, lb, ub] = fit_ellipses_and_reconstruct(img, n, ...
        best_angle, Pbase, K, p1, dh, top_point, bot_point, f, R, x, y, mask2, symmetry_angle);

    % Visualizing 3D Point Cloud
    visualize_point_cloud(lb, ub, profile, dh, surface_patterns, output_folder, ...
        img_name, point_cloud_flag);


    %% Runtime Reporting
    total_time = toc(total_tic);
    fprintf('\nTotal runtime: %.2fs \n', total_time);
end